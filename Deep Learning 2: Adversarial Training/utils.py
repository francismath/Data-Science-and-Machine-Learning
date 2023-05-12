import torch.nn as nn
import torchvision
import os

from torch.utils.data import DataLoader


def get_dataloader(save_path):
    if not os.path.exists(save_path):
        os.mkdir(save_path)

    train_data = torchvision.datasets.MNIST(
        root=save_path,
        train=True,
        transform=torchvision.transforms.ToTensor(),
        download=True
    )
    test_data = torchvision.datasets.MNIST(
        root=save_path,
        train=False,
        transform=torchvision.transforms.ToTensor(),
        download=True
    )
    train_load = DataLoader(dataset=train_data, batch_size=100, shuffle=True)
    test_load = DataLoader(dataset=test_data, batch_size=1, shuffle=True)
    return train_load, test_load


def init_weight(model):
    for m in model.modules():
        if isinstance(m, (nn.Conv2d, nn.Linear)):
            nn.init.xavier_uniform_(m.weight)
    return model


def net_accurary(data_iter, net, device):
    net.eval()
    right_sum, n = 0.0, 0
    for X, y in data_iter:
        X = X.to(device)
        y = y.to(device)
        right_sum += (net(X).argmax(dim=1) == y).float().sum().item()
        n += y.shape[0]
    net.train()
    return right_sum / n