<?php
// Directorio de imágenes PNG
$inputDir = __DIR__  ;
$outputDir = __DIR__;

// Crear el directorio de salida si no existe
if (!is_dir($outputDir)) {
    mkdir($outputDir, 0755, true);
}

// Obtener todas las imágenes PNG del directorio
$images = glob($inputDir . '/*.png');

// Verificar si hay imágenes para procesar
if (empty($images)) {
    echo "No se encontraron imágenes PNG en el directorio: $inputDir\n";
    exit;
}

foreach ($images as $imagePath) {
    // Nombre base del archivo (sin directorio)
    $imageName = basename($imagePath, '.png');

    // Crear el recurso de imagen desde el archivo PNG
    $image = imagecreatefrompng($imagePath);

    if ($image === false) {
        echo "Error al abrir la imagen: $imagePath\n";
        continue;
    }

    // Ruta de salida para el archivo WebP
    $outputPath = $outputDir . '/' . $imageName . '.webp';

    // Convertir y guardar la imagen en formato WebP
    if (imagewebp($image, $outputPath)) {
        echo "Convertida: $imagePath -> $outputPath\n";
    } else {
        echo "Error al convertir: $imagePath\n";
    }

    // Liberar la memoria del recurso de imagen
    imagedestroy($image);
}

echo "Conversión completada.\n";
?>
