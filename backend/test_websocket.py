import websockets
import asyncio

async def test_websocket():
    uri = "ws://127.0.0.1:8000/ws/stream_audio/"  # Adjust if needed

    async with websockets.connect(uri) as websocket:
        # Send a meditation prompt
        await websocket.send("Generate a mindfulness meditation session.")

        # Open file to store streamed audio
        with open("websocket_test_audio.opus", "wb") as f:
            while True:
                audio_chunk = await websocket.recv()

                if isinstance(audio_chunk, str):  # If received an error message
                    print(f"❌ Error from WebSocket: {audio_chunk}")
                    break

                f.write(audio_chunk)  # Write audio data to file

asyncio.run(test_websocket())
print("✅ WebSocket audio received and saved as 'websocket_test_audio.opus'.")
