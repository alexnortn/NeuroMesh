# Alex Norton 2016
# Neuro Processor 3.0

# Define paths
$inputdirectory = "I:\meshlab\oodsgc\"
$outputdirectory = "I:\meshlab\oodsgc-ts\"
$meshscript = "E:\GitHub\NeuroMesh\meshlab-scripts\neuro-processor-oodsgc-batch.mlx"

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
        # $outputfile = $item.Name;
        # Run Meshlab | Save as obj, only vertex + face normals
        meshlabserver -i $inputfile -o $outputfile -s $meshscript -om vc vn;
        Write-Host "Completed" + $item.Name;
    }
}

