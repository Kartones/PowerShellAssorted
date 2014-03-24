[Void][System.Reflection.Assembly]::LoadFile("C:\Windows\Microsoft.NET\Framework\v2.0.50727\System.Drawing.dll");

$processedSubfolder = "finished\";
$processedPrefix = "w_";
$watermarkFileName = "watermark.png";
$watermarkHeight = 350;
$watermarkWidth = 350;
$watermarkSeparation = 50;

$watermarkFile = get-childitem -Filter $watermarkFileName;
$directory = [System.IO.Path]::GetDirectoryName($watermarkFile.FullName) + "\";
if (!(Test-Path($directory + $processedSubfolder)))
{
	New-Item ($directory + $processedSubfolder) -ItemType directory;
}

$watermarkImage = [System.Drawing.Image]::FromFile($watermarkFile.FullName);

$images = get-childitem -Filter *.jpg;
foreach ($image in $images)
{
	$sourceItem = [System.Drawing.Image]::FromFile($image.FullName);
	$destination = $directory + $processedSubfolder + $processedPrefix + $image.Name;

	$x = $sourceItem.Width - $watermarkWidth - $watermarkSeparation;
	$y = $sourceItem.Height - $watermarkHeight - $watermarkSeparation;
	$position = New-Object System.Drawing.Point($x, $y);

	$destinationGraphicsObject = [System.Drawing.Graphics]::FromImage($sourceItem);
	$destinationGraphicsObject.DrawImage($watermarkImage, $position);

	$sourceItem.Save($destination);
	$sourceItem.Dispose();
	Write-Host "WATERMARKED:" , $destination;
}

$watermarkImage.Dispose();