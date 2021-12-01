# $Date = Get-Date

# # define parameters for splatting
# $param = @{
#   FromSymbol ='BTC'
#   ToSymbol ='USD'
#   DataInterval ='Day'
#   Since = $Date.AddDays(-30)
#   Until = $Date
# }

# # capture the market closing price for 30 days
# $BTC = Get-CoinPriceHistory @param | ForEach-Object Close
# Show-Graph -Datapoints $BTC -GraphTitle 'BitCoin [USD]' -YAxisStep 200

$Date = Get-Date

$symbols = @{
    "Bitcoin" = "BTC"
    "Ethereum" = "ETH"
    "Solana" = "SOL"
    "Binance Coin" = "BNB"
    "MOBOX" = "MBOX"
    "Shiba Inu" = "SHIB"
    "Terra" = "LUNA"
    "Polygon" = "MATIC"
    "XRP" = "XRP"
}

function Get-Symbols {
    Write-Host "=============== CRYPTO OPTIONS ===============" -f yellow
    
    $symbols.keys | Foreach-Object {Write-Host  "$_ - $($symbols[$_])"}

    Write-Host "=======================================" -f yellow
    Write-Host

    $FromSymbol = Read-Host "Which coin do you want to get information about?"

    return $FromSymbol
}

function Get-Crypto{
    try {
        Get-InstalledModule -Name "Coin"
    }
    catch {
        Install-Module -Name "Coin" -Force
    }
    try {
        Get-InstalledModule -Name "Graphical"
    }
    catch {
        Install-Module -Name "Graphical" -Force
    }

    Clear-Host

    $FromSymbol = Get-Symbols
    if ($symbols.ContainsKey($FromSymbol) -eq $false) {
        Get-Crypto
    }
    

    Write-Host "=============== TIME FRAME OPTIONS ===============" -f yellow
    Write-Host "1 - 1 Day"
    Write-Host "2 - 1 Month (30 days)"
    Write-Host "3 - 3 Months (90 days)"
    Write-Host "4 - 6 Months (180 days)"
    Write-Host "5 - 1 Year (365 days)"
    Write-Host "=======================================" -f yellow
    Write-Host
    $TimeFrame = Read-Host "What time frame you want do display? (DAYS)"
    $Since = 0
    switch ($TimeFrame) {
        '1' { $Since = -1 }    
        '2' { $Since = -30 }    
        '3' { $Since = -30 * 3 }    
        '4' { $Since = -30 * 6 }    
        '5' { $Since = -365 }    
        Default {}
    }

    $param = @{
        FromSymbol = $symbols[$FromSymbol]
        ToSymbol ='USD'
        DataInterval ='Day'
        Since = $Date.AddDays($Since)
        Until = $Date
    }

    $Result = Get-CoinPriceHistory @param | ForEach-Object Close
    Show-Graph -Datapoints $Result -GraphTitle  "[$FromSymbol] - [USD]"-YAxisStep 200

    $continue = Read-Host "Would you like to try another crypto or time frame? Yes(y) and No (n)"

    if ($continue -eq 'y') {
        Get-Crypto
    }else {
        exit
    }
}