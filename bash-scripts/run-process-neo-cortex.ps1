# Alex Norton 2016
# Neuro Processor 3.0

# Define paths
# $inputdirectory = "I:\meshlab\bipolar\"
$inputdirectory = "E:\Drive\Dropbox (MIT)\Projects\Eyewire\FullTime\NEO\piriform_downsample_2\"
$outputdirectory = "E:\Drive\Dropbox (MIT)\Projects\Eyewire\FullTime\NEO\piriform_downsample_3\"
$meshscript = "E:\GitHub\NeuroMesh\meshlab-scripts\neo_cortex3_downsample.mlx"

# Grab all the items in specified directory
$items = Get-ChildItem -Path $inputdirectory

# Loop through all items
foreach ($item in $items) {
    # Check for obj extension
    if ($item.extension -eq ".obj") {
        # Do something
        Write-Host "Processing" + $item.Name;
        # Declare I/O files
        $inputfile = $inputdirectory + $item
        $outputfile = $outputdirectory + $item.Name;
        Write-Host "Output:" + $outputfile;
        # Run Meshlab | Save as obj, only vertex + face normals
        meshlabserver -i $inputfile -o $outputfile -s $meshscript -om vc vn;
        Write-Host "Completed" + $item.Name;
    }
}

