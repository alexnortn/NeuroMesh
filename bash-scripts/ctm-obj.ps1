# Alex Norton 2016
# Neuro Processor 3.0

# Define paths
$inputdirectory = "I:\neurons\ganglion\meshesHi11\"
$outputdirectory = "I:\neurons\ganglion\obj\"
$meshscript = "c:\neuro-processor.mlx" # Could simultaneously downsample + smooth neurons --> Next time
$inputFormat = ".ctm"
$outputFormat = ".obj"

# Grab all the items in specified directory
$items = Get-ChildItem -Path $inputdirectory

# Loop through all items
foreach ($item in $items) {
    # Check for ctm extension
    if ($item.extension -eq $inputFormat) {
        # Do something
        Write-Host "Processing" + $item.Name;
        # Declare I/O files
        $inputfile = $inputdirectory + $item
        $outputfile = $outputdirectory + ($item.Name).Split("{.}")[0] + $outputFormat;
        Write-Host "Output:" + $outputfile;
        # Run Meshlab | Save as obj, only vertex + face normals
        # meshlabserver -i $inputfile -o $outputfile -s $meshscript -om vc vn;
        ctmconv $inputfile $outputfile 
        Write-Host "Completed" + $item.Name;
    }
}

