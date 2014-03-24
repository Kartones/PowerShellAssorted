[Void][System.Reflection.Assembly]::LoadFile( "C:\Windows\Microsoft.NET\Framework\v2.0.50727\System.Drawing.dll");

$thumbsSubfolder = "thumbs\";
$thumbsPrefix = "t_";
$listFileName = "thumbs.list";
$listFileSeparatorToken = "||";

$images = get-childitem -Filter *.jpg | Sort-Object LastWriteTime -descending;
foreach ($image in $images)
{ 
	if (!$directory)
	{
		$directory = [System.IO.Path]::GetDirectoryName($image.FullName) + "\";
		if (!(Test-Path ($directory + $thumbsSubfolder)))
		{
			New-Item ($directory + $thumbsSubfolder) -ItemType directory;
		}
		# Overrides if existing, no need to manually delete
        $listFile = [System.IO.StreamWriter] ($directory + $listFileName);
	}

	$fullImage = [System.Drawing.Image]::FromFile($image.FullName); 
	$thumb = $fullImage.GetThumbnailImage(150, 150, $null, [intptr]::Zero); 
	$destination = $directory + $thumbsSubfolder + $thumbsPrefix + $image.Name;
	Write-Host "THUMB:" , $destination;
	$thumb.Save($destination);

	$listFile.WriteLine($thumbsPrefix + $image.Name + $listFileSeparatorToken + $image.Name);

	$fullImage.Dispose(); 
	$thumb.Dispose();
}

if ($listFile)
{
    $listFile.close();
}