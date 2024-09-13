#!/usr/bin/pwsh
# Script made by Adrian Chmiel (chmieladr)
# Upscales all the provided videos to 3840x2160 resolution

# Check if the user provided any input files
if ($args.Count -eq 0) {
    Write-Host "No input files provided!"
    Write-Host "Usage: $0 <input_file1> <input_file2> ..."
    exit 1
}

# Create a new directory for the upscaled videos
New-Item -Path "./upscaled" -ItemType Directory -Force

foreach ($input_file in $args) {
    # Redirect the output to the created directory
    $output_file = Join-Path "upscaled" (Split-Path $input_file -Leaf)

    # Upscale the video to 3840x2160 resolution using the NVIDIA NVENC encoder
    ffmpeg -i "$input_file" -vf scale=3840:2160:flags=neighbor -c:v h264_nvenc -profile:v high -preset slow -rc vbr -qmin 17 -qmax 22 -multipass 2 -b:v 0 -c:a copy "$output_file"

    # Confirmation message
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$input_file -> The video has been successfully upscaled!"
    } else {
        Write-Host "$input_file -> An error occurred while upscaling the video!"
    }
}
