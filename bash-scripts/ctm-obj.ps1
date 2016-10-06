# Alex Norton 2016
# Neuro Processor 3.0

# Define paths
$inputdirectory = "E:\Drive\Dropbox (MIT)\Projects\Eyewire\FullTime\NEO\3DSMAX\sceneassets\meshes\pinky\3\"
$outputdirectory = "E:\Drive\Dropbox (MIT)\Projects\Eyewire\FullTime\NEO\3DSMAX\sceneassets\meshes\pinky\3.1\"
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

        ctmconv $inputfile $outputfile 

        Write-Host "Completed" + $item.Name;
    }
}

