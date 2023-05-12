import torch.nn as nn
import torch
import os
import torch.nn.functional as F
import numpy as np

from rich.progress import track
from model import VGGConv
from utils import net_accurary, init_weight
from utils import get_dataloader
from attack import pgd_attack


def train(model, train_loader, test_loader, last_epoch, save_path):

    loss = nn.CrossEntropyLoss()
    opt = torch.optim.SGD(model.parameters(), lr=0.01)

    acc_list_test = []
    acc_list_train = []

    model.train()
    for epoch in track(range(last_epoch)):
        for i, (x, y) in enumerate(train_loader):
            x = x.to(device)
            y = y.to(device)

            out = model(x)
            _loss = loss(out, y)
            opt.zero_grad()
            _loss.backward()
            opt.step()

        acc_avg_test = net_accurary(test_loader, model, device)
        acc_avg_train = net_accurary(train_loader, model, device)

        acc_list_train.append(acc_avg_train)
        acc_list_test.append(acc_avg_test)

    if not os.path.exists(save_path):
        os.mkdir(save_path)
    torch.save(model.state_dict(), save_path+'/model.pth')
    print("Avg acc on training set: {} \n Avg acc on test set: {}".format(sum(acc_list_train)/len(acc_list_train),
                                                                          sum(acc_list_test)/len(acc_list_test)))


def test_and_attack(model, test_loader, epsilon, alpha, step=10, target=None):

    model.eval()
    ad_img_list = []
    label_store = []
    confidence = []
    error_pred = []

    for idx, (image, label) in enumerate(test_loader):
        img, label = image.to(device), label.to(device)
        ad_img = pgd_attack(img, model, label, epsilon, alpha, step, device, target=target)

        ori_outputs = model(img)
        outputs = F.log_softmax(ori_outputs, dim=1)
        ori_pred = outputs.max(1, keepdim=True)[1]
        ori_confidence = F.softmax(ori_outputs, dim=1)[:, ori_pred[:, 0]]

        ad_outputs = model(ad_img)
        outputs = F.log_softmax(ad_outputs, dim=1)
        ad_pred = outputs.max(1, keepdim=True)[1]
        ad_confidence = F.softmax(ad_outputs, dim=1)[:, ad_pred[:, 0]]

        ad_img_list.append(ad_img)
        label_store.append(label.numpy())
        confidence.append([ad_confidence.detach().numpy(), ori_confidence.detach().numpy()])
        error_pred.append(ad_pred.detach().numpy())

        if idx > 2:
            break

    return ad_img_list, confidence, label_store, error_pred


if __name__ == "__main__":

    use_cuda = True
    weight_path = './weight/model.pth'
    epsilon = 0.3
    alpha = 0.02
    step = 20

    print("CUDA Available: ", torch.cuda.is_available())
    device = torch.device("cuda" if (use_cuda and torch.cuda.is_available()) else "cpu")

    model = VGGConv().to(device)
    model = init_weight(model)
    train_set, val_set = get_dataloader('./data')

    if not os.path.isfile(weight_path):
        print("Training Network for Attack")
        train(model, train_set, val_set, 30, './weight')
    else:
        model.load_state_dict(torch.load(weight_path, map_location='cpu'))

    print("Prepare attack")
    ad_img_list, confidence, label_store, error_pred = \
        test_and_attack(model, val_set, epsilon, alpha, step)


    print()






