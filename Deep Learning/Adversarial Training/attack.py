import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np


def pgd_attack(img, model, labels, epsilon, alpha, step, device, target=None):

    loss = nn.NLLLoss()
    ori_images = img.data

    for i in range(step):
        img.requires_grad = True
        outputs = model(img)
        model.zero_grad()
        if target is not None:
            fake_label = torch.Tensor([int(target)]).long().to(device)
            cost = loss(outputs, labels) - loss(outputs, fake_label)
            # print()
        else:
            cost = loss(outputs, labels).to(device)
            print()
        cost.backward()

        adv_images = img + alpha * img.grad.sign()
        eta = torch.clamp(adv_images - ori_images, min=-epsilon, max=epsilon)
        img = torch.clamp(ori_images + eta, min=0, max=1).detach_()

    return img