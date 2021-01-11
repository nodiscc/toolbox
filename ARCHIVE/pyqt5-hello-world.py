#!/usr/bin/python3
# -*- coding: utf-8 -*-

"""
ZetCode PyQt5 tutorial 

In this example, we create a simple
window in PyQt5.

Author: Jan Bodnar
Website: zetcode.com 
Last edited: August 2017
"""

import sys
from PyQt5.QtWidgets import (QWidget, QCheckBox, 
    QHBoxLayout, QVBoxLayout, QLabel,
    QToolTip, QPushButton, QApplication)
from PyQt5.QtGui import QIcon
from PyQt5.QtGui import QFont
from PyQt5.QtCore import Qt


class Example(QWidget):
    
    def __init__(self):
        super().__init__()
        self.initUI()
        
        
    def initUI(self):
        button_quit = QPushButton('Quit', self)
        button_quit.setToolTip('This is a <b>QPushButton</b> widget')
        button_quit.clicked.connect(QApplication.instance().quit)

        checkbox_firefox = QCheckBox('Customize Firefox', self)
        checkbox_packages = QCheckBox('Install more packages', self)
        checkbox_xfce4settings = QCheckBox('More settings...', self)
        # cb.toggle()
        # cb.stateChanged.connect(self.changeTitle)

        font_main = QFont('Roboto', 10)
        font_bold = QFont('Roboto', pointSize=10, weight=QFont.Bold)
        label_services = QLabel('Services', self)
        label_services.setFont(font_bold)

        checkbox_service_bluetooth = QCheckBox('Enable Bluetooth support', self)
        checkbox_service_cups = QCheckBox('Enable printer support (CUPS)', self)
        checkbox_service_samba = QCheckBox('Enable file sharing service (Samba)', self)


        hbox = QHBoxLayout()
        hbox.addStretch(1)
        hbox.addWidget(button_quit)

        vbox = QVBoxLayout()
        vbox.addWidget(checkbox_firefox)
        vbox.addWidget(checkbox_packages)
        vbox.addWidget(checkbox_xfce4settings)

        vbox.addWidget(label_services)
        vbox.addWidget(checkbox_service_bluetooth)
        vbox.addWidget(checkbox_service_cups)
        vbox.addWidget(checkbox_service_samba)
        vbox.addStretch(1)
        vbox.addLayout(hbox)
        
        self.setLayout(vbox) 



        self.setGeometry(300, 300, 300, 220)
        self.setWindowTitle('Icon')
        self.setWindowIcon(QIcon('/home/live/firefox.png'))
        self.setFont(font_main)
        self.show()

    # def changeTitle(self, state):
      
    #     if state == Qt.Checked:
    #         self.setWindowTitle('QCheckBox')
    #     else:
    #         self.setWindowTitle(' ')


if __name__ == '__main__':
    
    app = QApplication(sys.argv)
    ex = Example()
    sys.exit(app.exec_())
