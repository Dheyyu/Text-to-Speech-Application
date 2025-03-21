document.addEventListener('DOMContentLoaded', function () {
    const textInput = document.getElementById('text-input');
    const voiceSelect = document.getElementById('voiceSelect');
    const generateBtn = document.getElementById('generateBtn');
    const loadingIndicator = document.getElementById('loadingIndicator');
    const errorMessage = document.getElementById('errorMessage');
    const audioContainer = document.getElementById('audioContainer');
    const audioPlayer = document.getElementById('audioPlayer');
    const downloadBtn = document.getElementById('downloadBtn');

    // Replace this with your actual API Gateway URL
    const apiUrl = 'YOUR_API_GATEWAY_URL';

    generateBtn.addEventListener('click', async function () {
        const text = textInput.value.trim();

        if (!text) {
            showError('Please enter some text to convert.');
            return;
        }

        // Show loading indicator
        loadingIndicator.classList.add('visible');
        audioContainer.classList.remove('visible');
        errorMessage.classList.remove('visible');
        generateBtn.disabled = true;

        try {
            const response = await fetch(apiUrl,
                {
                    method: 'POST',
                    headers:
                    {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify
                        ({
                            text: text,
                            voice: voiceSelect.value
                        })
                });

            if (!response.ok) {
                throw new Error('Failed to convert text to speech.');
            }

            const data = await response.json();

            // Assuming the API returns a URL to the audio file
            if (data.audioUrl) {
                audioPlayer.src = data.audioUrl;
                audioContainer.classList.add('visible');

                // Set up download button
                downloadBtn.onclick = function () {
                    const a = document.createElement('a');
                    a.href = data.audioUrl;
                    a.download = 'speech.mp3';
                    document.body.appendChild(a);
                    a.click();
                    document.body.removeChild(a);
                };
            }
            else {
                throw new Error('No audio URL received from the server.');
            }
        }
        catch (error) {
            showError(error.message);
        }
        finally {
            loadingIndicator.classList.remove('visible');
            generateBtn.disabled = false;
        }

    });

    function showError(message) {
        errorMessage.textContent = message;
        errorMessage.classList.add('visible');
        audioContainer.classList.remove('visible');
    }

});