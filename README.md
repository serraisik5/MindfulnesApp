## Create venv than do pip install requirements instead of below seperate pip installs
pip install -r requirements.txt

### django-channels → Enables WebSocket support in Django
pip install django
pip install django daphne django-channels openai
pip install djangorestframework
pip install channels
pip install websockets

### create django project -- do not use
django-admin startproject backend
python manage.py startapp api

python manage.py makemigrations
python manage.py migrate

### run backend server
cd backend
python manage.py runserver

### run django with websockets
daphne -b 0.0.0.0 -p 8000 backend.asgi:application

### flutter
brew install flutter
export PATH="$PATH:`brew --prefix`/bin"
flutter doctor

### root directory - do not use
flutter create frontend

start flutter
cd frontend
flutter run

## Run tests
python test_websocket.py (backend ayakta olmalı)
python test_openai_turbo.py )(API key koymak lazım) (Sakın key'i pushlamayın, git error veriyo)
python test_openai_realtime.py