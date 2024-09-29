import sys
import os
import winshell
from win32com.client import Dispatch
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton, QVBoxLayout, QLabel, QMessageBox, QRubberBand
from PyQt5.QtCore import Qt, QRect, QSize
from PyQt5.QtGui import QScreen, QPixmap, QPainter, QPen, QColor
from datetime import datetime

class ScreenshotApp(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()
        self.start = None
        self.end = None
        self.screenshot = None
        self.cropping = False
        self.rubberband = QRubberBand(QRubberBand.Rectangle, self)

    def initUI(self):
        self.setWindowTitle('Screenshot Tool')
        self.setGeometry(100, 100, 300, 250)

        layout = QVBoxLayout()

        self.label = QLabel('Click "Take Screenshot" to start')
        layout.addWidget(self.label)

        self.btn = QPushButton('Take Screenshot', self)
        self.btn.clicked.connect(self.take_screenshot)
        layout.addWidget(self.btn)

        self.create_batch_btn = QPushButton('Create Batch File', self)
        self.create_batch_btn.clicked.connect(self.create_batch_file)
        layout.addWidget(self.create_batch_btn)

        self.create_shortcut_btn = QPushButton('Create Desktop Shortcut', self)
        self.create_shortcut_btn.clicked.connect(self.create_desktop_shortcut)
        layout.addWidget(self.create_shortcut_btn)

        self.quit_btn = QPushButton('Quit', self)
        self.quit_btn.clicked.connect(QApplication.instance().quit)
        layout.addWidget(self.quit_btn)

        self.setLayout(layout)

    def take_screenshot(self):
        self.hide()
        screen = QApplication.primaryScreen()
        self.screenshot = screen.grabWindow(0)
        self.show()
        self.setWindowState(Qt.WindowActive)
        self.activateWindow()
        self.showFullScreen()
        self.setWindowFlags(Qt.FramelessWindowHint)
        self.label.setText('Click and drag to select area')
        self.setCursor(Qt.CrossCursor)
        self.cropping = True

    def paintEvent(self, event):
        if self.screenshot:
            painter = QPainter(self)
            painter.drawPixmap(self.rect(), self.screenshot)

            if self.cropping:
                painter.setPen(QPen(QColor(255, 0, 0, 100), 2, Qt.SolidLine))
                painter.setBrush(QColor(255, 0, 0, 100))
                painter.drawRect(QRect(self.start or QPoint(), self.end or QPoint()))

    def mousePressEvent(self, event):
        if self.cropping:
            self.start = event.pos()
            self.rubberband.setGeometry(QRect(self.start, QSize()))
            self.rubberband.show()

    def mouseMoveEvent(self, event):
        if self.cropping:
            self.end = event.pos()
            self.rubberband.setGeometry(QRect(self.start, self.end).normalized())

    def mouseReleaseEvent(self, event):
        if self.cropping:
            self.end = event.pos()
            self.rubberband.hide()
            self.cropping = False
            self.capture_screenshot()

    def capture_screenshot(self):
        if self.start and self.end:
            rect = QRect(self.start, self.end).normalized()
            cropped = self.screenshot.copy(rect)
            downloads_path = os.path.expanduser("~/Downloads")
            filename = f"screenshot_{datetime.now().strftime('%Y%m%d_%H%M%S')}.png"
            filepath = os.path.join(downloads_path, filename)
            cropped.save(filepath, 'PNG')

            self.label.setText(f'Screenshot saved as {filename}')
            self.showNormal()
            self.setWindowFlags(Qt.Window)
            self.show()
            self.start = self.end = None
            self.screenshot = None
            self.setCursor(Qt.ArrowCursor)

    def create_batch_file(self):
        batch_content = f"""@echo off
call C:\\Users\\%USERNAME%\\Anaconda3\\Scripts\\activate.bat screenshot_env
python "{os.path.abspath(__file__)}"
pause
"""
        desktop = winshell.desktop()
        batch_path = os.path.join(desktop, "run_screenshot.bat")
        with open(batch_path, "w") as batch_file:
            batch_file.write(batch_content)
        QMessageBox.information(self, "Batch File Created", f"Batch file created at:\n{batch_path}")

    def create_desktop_shortcut(self):
        desktop = winshell.desktop()
        path = os.path.join(desktop, "Screenshot Tool.lnk")
        target = sys.executable
        wDir = os.path.dirname(os.path.abspath(__file__))
        icon = sys.executable

        shell = Dispatch('WScript.Shell')
        shortcut = shell.CreateShortCut(path)
        shortcut.Targetpath = target
        shortcut.WorkingDirectory = wDir
        shortcut.IconLocation = icon
        shortcut.Arguments = f'"{os.path.abspath(__file__)}"'
        shortcut.save()
        QMessageBox.information(self, "Shortcut Created", f"Desktop shortcut created at:\n{path}")

if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = ScreenshotApp()
    ex.show()
    sys.exit(app.exec_())
