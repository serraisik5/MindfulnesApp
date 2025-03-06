
import openai

## OPENAI_API_KEY = ""


def test_openai_turbo_tts():
    client = openai.OpenAI(api_key=OPENAI_API_KEY)

    print("🗣️ Generating meditation session using GPT-4 Turbo...")

    # Request a GPT-4 Turbo response in streaming mode
    response = client.chat.completions.create(
        model="gpt-4-turbo",
        messages=[{"role": "system", "content": "You are a mindfulness meditation guide."},
                  {"role": "user", "content": "Generate a guided meditation session for relaxation."}],
        stream=True  # ✅ Enable streaming
    )

    full_text = ""  # Store all chunks to pass to TTS

    for chunk in response:
        if chunk and hasattr(chunk.choices[0].delta, "content"):  # Ensure chunk contains text
            text_chunk = chunk.choices[0].delta.content
            if text_chunk:
                full_text += text_chunk
                print(f"🗣️ GPT-4 says: {text_chunk}")  # Log text in real-time

    if not full_text.strip():  # 🚨 Check if GPT-4 Turbo returned text
        print("❌ Error: GPT-4 Turbo did not generate any text.")
        return

    print("✅ GPT-4 Turbo finished generating text.")
    print(f"📄 Full Text: {full_text[:500]}...")  # Show first 500 chars for debugging

    # Convert the full response to speech
    print("🎙 Converting text to speech...")
    tts_response = client.audio.speech.create(
        model="tts-1",
        voice="alloy",  # Options: alloy, echo, fable, onyx, nova, shimmer
        input=full_text.strip()  # ✅ Ensure input is not empty
    )

    # Save the audio file locally
    with open("test_turbo_audio.mp3", "wb") as f:
        f.write(tts_response.content)

    print("✅ Audio saved as 'test_turbo_audio.mp3'. Play it to verify.")

if __name__ == "__main__":
    test_openai_turbo_tts()
