pip install -r requirements.txt

### create django project -- do not use
django-admin startproject backend
python manage.py startapp api

python manage.py makemigrations
python manage.py migrate

### run backend server
cd backend
python manage.py runserver

### run django with websockets
daphne -b 0.0.0.0 -p 8001 backend.asgi:application

## connect to websocket from backend
wscat -c ws://127.0.0.1:8001/ws/meditation/
wscat -c ws://127.0.0.1:8001/ws/meditation/ -H "Authorization: Bearer <your_access_token>"
## give input as json
{ "title": "Sleep", "duration": 1, "voice": "coral", "background_noise": "rainy" }


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
- python test_websocket.py (backend ayakta olmalı)
- python test_openai_turbo.py (API key koymak lazım) (Sakın key'i pushlamayın, git error veriyo)
- python test_openai_realtime.py


## For user create 
{
  "email": "serra@example.com",
  "password": "serra123",
  "first_name": "Serra"
}

POST http://127.0.0.1:8000/api/user/create/

## For user login
{
  "email": "serra@example.com",
  "password": "serra123"
}

POST http://127.0.0.1:8000/api/token/
(response will have access/refresh token)

## Use token for auth endpoints
Authorization: Bearer <access_token>

## refresh token
POST http://127.0.0.1:8000/api/token/refresh/

## reach to saved audios
http://localhost:8000/media/sessions/audio/23_audio.wav

