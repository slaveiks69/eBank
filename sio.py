from flask_socketio import *

class sio:
    @classmethod
    def __init__(self, app):
        self.app = SocketIO(app, cors_allowed_origins="*", manage_session=True)

    @classmethod
    def get(self):
        return self.app
        
    @classmethod
    def broadcast(self, func, args):
        self.app.emit(func, args)