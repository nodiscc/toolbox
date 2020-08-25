#!/usr/bin/python
import subprocess
import gi
gi.require_version('Gio', '2.0')
from gi.repository import Gio

def run_config():
    raise


Application = Gio.Application.new("hello.world", Gio.ApplicationFlags.FLAGS_NONE)
Application.register()
Notification = Gio.Notification.new("Hello world")
Notification.set_body("This is an example notification.")
Icon = Gio.ThemedIcon.new("dialog-information")
Notification.set_icon(Icon)
Notification.add_button("Label","app.action")
action = Gio.SimpleAction.new("app.action")
action.connect("activate", run_config)
Application.add_action(action)
Application.send_notification(None, Notification)
