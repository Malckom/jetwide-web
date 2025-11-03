const fs = require('fs');
const path = require('path');
const sharp = require('sharp');

const heroDir = path.join(__dirname, 'assets', 'images', 'Hero-Section');
const outputQuality = 70;

async function convertImage(inputPath) {
  const { name } = path.parse(inputPath);
  const outputPath = path.join(heroDir, `${name}.webp`);

  if (fs.existsSync(outputPath)) {
    return;
  }

  try {
    await sharp(inputPath)
      .webp({ quality: outputQuality })
      .toFile(outputPath);
    console.log(`Converted ${path.basename(inputPath)} → ${path.basename(outputPath)}`);
  } catch (error) {
    console.error(`❌ Failed to convert ${inputPath}:`, error.message);
  }
}

async function run() {
  if (!fs.existsSync(heroDir)) {
    console.error('Hero images directory not found:', heroDir);
    process.exit(1);
  }

  const files = fs.readdirSync(heroDir)
    .filter(file => file.match(/\.(jpe?g|png)$/i))
    .map(file => path.join(heroDir, file));

  if (!files.length) {
    console.log('No hero images found to convert.');
    return;
  }

  for (const file of files) {
    // Skip PNG duplicates artificially numbered e.g. (4).png when same .jpg exists
    await convertImage(file);
  }

  console.log('✅ Hero images conversion complete.');
}

run();
