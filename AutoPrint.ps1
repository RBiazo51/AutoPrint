cls
$path = "C:\Users\Ryan\Downloads\"
$DefPrinter=Get-WmiObject -Query " SELECT * FROM Win32_Printer WHERE Default=$true" | Select-Object -ExpandProperty Name
$Printer_net = New-Object -COM WScript.Network

function autoPrint{
param(
[String]$NameInclude,
[String]$NameExclude = 'abcdefg',
[String]$PrinterName,
[String]$FolderName
)
$results = Get-ChildItem -Path $path -File | Where-Object {$_.Extension -eq ".pdf"}
    foreach ($file in $results) {
    $date = Get-Date -format "HH:mm:ss"
        if($file.Name -like "*$NameInclude*" -and $file.Name -notlike "*$NameExclude*") {
            $Printer_net = New-Object -COM WScript.Network
            $Printer_net.SetDefaultPrinter($PrinterName)
            Write-Output "$date - $PrinterName : $FolderName \ $file"
            Start-Process -FilePath $path\$file -Verb Print -PassThru | %{sleep 2;$_} | kill
            Move-Item -Path $path'\'$file -Destination C:\Users\Ryan\Downloads\Printed\$FolderName
        }
   
    }
$Printer_net.SetDefaultPrinter($DefPrinter)
}

while($true){
    autoPrint -PrinterName 'Canon 2' -NameInclude 'Picking Operations' -FolderName 'Picking Operations'
    autoPrint -PrinterName 'ZDesigner GK420d' -NameInclude 'Easypost-1Z' -FolderName 'UPS Labels'
    autoPrint -PrinterName 'Canon 2' -NameInclude 'Easypost-9405' -FolderName 'USPS Labels'
    autoPrint -PrinterName 'Canon 2' -NameInclude 'HQ_OUT' -FolderName 'Delivery Slips' -NameExclude 'Picking Operations'
}