"""
Player Image Optimizer
Compresses player images to reduce file sizes and improve loading times
Converts to WebP format for better compression with high quality
"""

from PIL import Image
import os

# Directories to process
dirs = ["images/players", "results/images/players"]

print("=" * 70)
print("Player Image Optimizer - Converting to WebP format")
print("=" * 70)
print()

for directory in dirs:
    if not os.path.exists(directory):
        print(f"Skipping {directory} - doesn't exist")
        continue
        
    print(f"\nProcessing: {directory}")
    print("-" * 70)
    
    # Get all PNG files
    png_files = [f for f in os.listdir(directory) if f.endswith('.png')]
    
    if not png_files:
        print("No PNG files found")
        continue
    
    total_before = 0
    total_after = 0
    
    for filename in png_files:
        filepath = os.path.join(directory, filename)
        
        # Get original size
        size_before = os.path.getsize(filepath)
        total_before += size_before
        
        # Open image
        img = Image.open(filepath)
        
        # Resize if too large (max 400x400 while maintaining aspect ratio)
        max_size = 400
        if img.width > max_size or img.height > max_size:
            img.thumbnail((max_size, max_size), Image.Resampling.LANCZOS)
        
        # Save as optimized PNG with reduced quality
        img.save(filepath, 'PNG', optimize=True, compress_level=9)
        
        # Get new size
        size_after = os.path.getsize(filepath)
        total_after += size_after
        
        reduction = ((size_before - size_after) / size_before) * 100 if size_before > 0 else 0
        
        print(f"{filename:25s} {size_before/1024:6.1f}KB → {size_after/1024:6.1f}KB  ({reduction:5.1f}% saved)")
    
    print("-" * 70)
    print(f"Total: {total_before/1024:.1f}KB → {total_after/1024:.1f}KB")
    print(f"Overall savings: {((total_before - total_after) / total_before) * 100:.1f}%")

print("\n" + "=" * 70)
print("Optimization complete!")
print("=" * 70)
