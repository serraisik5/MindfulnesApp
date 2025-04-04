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
daphne -b 0.0.0.0 -p 8000 backend.asgi:application

## connect to websocket from backend
wscat -c ws://127.0.0.1:8001/ws/meditation/
## give input as json
{ "title": "Sleep", "duration": 1, "voice": "nova", "background_noise": "rainy" }


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
  "username": "sisik",
  "first_name": "Serra",
  "last_name": "Isik",
  "gender": "female",
  "birthday": "2002-05-29",
  "password": "serra123"
}
POST http://127.0.0.1:8000/api/user/create/

## For user login
{
  "username": "sisik",
  "password": "serra123"
}

POST http://127.0.0.1:8000/api/token/
(response will have access/refresh token)

## Use token for auth endpoints
Authorization: Bearer <access_token>

## refresh token
POST http://127.0.0.1:8000/api/token/refresh/
