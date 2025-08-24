import cv2
import numpy as np
import matplotlib.pyplot as plt

# 画像を読み込む
IMAGE_PATH = "image/"
img = cv2.imread(IMAGE_PATH + "segment_test.png")

# 画像をグレースケールに変換
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

# グレースケール画像を表示
plt.imshow(gray, cmap='gray')
plt.show()

