"""
Logo Image Optimizer
Compresses PNG images in the Logos folder to reduce file sizes and improve loading times
"""

from PIL import Image
import os

logos_dir = "Logos"

# Get all PNG files in Logos directory
logo_files = [f for f in os.listdir(logos_dir) if f.endswith('.png')]

print(f"Found {len(logo_files)} logo files to optimize")
print("-" * 60)

total_before = 0
total_after = 0

for filename in logo_files:
    filepath = os.path.join(logos_dir, filename)
    
    # Get original size
    size_before = os.path.getsize(filepath)
    total_before += size_before
    
    # Open and optimize image
    img = Image.open(filepath)
    
    # Convert to RGB if needed (removes alpha channel for JPEG compatibility)
    if img.mode == 'RGBA':
        # Keep PNG format but optimize
        img.save(filepath, 'PNG', optimize=True, quality=85)
    else:
        img.save(filepath, 'PNG', optimize=True, quality=85)
    
    # Get new size
    size_after = os.path.getsize(filepath)
    total_after += size_after
    
    reduction = ((size_before - size_after) / size_before) * 100
    
    print(f"{filename}")
    print(f"  Before: {size_before / 1024:.1f} KB")
    print(f"  After:  {size_after / 1024:.1f} KB")
    print(f"  Saved:  {reduction:.1f}%")
    print()

print("-" * 60)
print(f"Total before: {total_before / 1024:.1f} KB")
print(f"Total after:  {total_after / 1024:.1f} KB")
print(f"Total saved:  {((total_before - total_after) / total_before) * 100:.1f}%")
