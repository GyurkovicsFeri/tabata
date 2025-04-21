 #!/bin/bash

# Create phase_start.mp3 (high pitch beep)
ffmpeg -f lavfi -i "sine=frequency=1000:duration=0.5" -c:a libmp3lame -q:a 2 assets/audio/phase_start.mp3

# Create phase_end.mp3 (low pitch beep)
ffmpeg -f lavfi -i "sine=frequency=500:duration=0.5" -c:a libmp3lame -q:a 2 assets/audio/phase_end.mp3

# Create countdown.mp3 (three quick beeps)
ffmpeg -f lavfi -i "sine=frequency=800:duration=0.1" -c:a libmp3lame -q:a 2 assets/audio/countdown.mp3