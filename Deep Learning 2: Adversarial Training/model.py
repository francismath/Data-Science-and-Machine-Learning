import torch.nn as nn


class VGGConv(nn.Module):
    def __init__(self):
        super(VGGConv, self).__init__()
        self.block_1 = nn.Sequential(
            nn.Conv2d(1, 16, kernel_size=3, stride=1, padding=1),
            nn.BatchNorm2d(16, momentum=0.2, affine=True),
            nn.ReLU(True),
            nn.Conv2d(16, 16, kernel_size=3, padding=1),
            nn.BatchNorm2d(16),
            nn.ReLU(True),
            nn.MaxPool2d(kernel_size=2, stride=2)
        )

        self.block_2 = nn.Sequential(
            nn.Conv2d(16, 32, kernel_size=3, stride=1, padding=1),
            nn.BatchNorm2d(32, momentum=0.2, affine=True),
            nn.ReLU(True),
            nn.Conv2d(32, 32, kernel_size=3, padding=1),
            nn.BatchNorm2d(32),
            nn.ReLU(True),
            nn.MaxPool2d(kernel_size=2, stride=2)
        )

        self.block_3 = nn.Sequential(
            nn.Conv2d(32, 64, kernel_size=3, stride=1, padding=1),
            nn.BatchNorm2d(64, momentum=0.2, affine=True),
            nn.ReLU(True),
            nn.Conv2d(64, 64, kernel_size=3, padding=1),
            nn.BatchNorm2d(64),
            nn.ReLU(True)
        )

        self.fc_classifier = nn.Sequential(
            nn.Linear(64*7*7, 128),
            nn.ReLU(True),
            nn.Dropout(),
            nn.Linear(128, 10))

    def forward(self, x):
        block_1_out = self.block_1(x)
        block_2_out = self.block_2(block_1_out)
        block_3_out = self.block_3(block_2_out)
        bs = block_3_out.shape[0]
        out = self.fc_classifier(block_3_out.view(bs, -1))
        return out
