# Config Variables
$outputFileName="$env:USERPROFILE\Videos\downloadLinks.txt"
$outputDirTemplate="$env:USERPROFILE\Videos\%(title)s.%(ext)s"

# Create new Output File
New-Item $outputFileName -ItemType File -Force | Out-Null
Clear-Content $outputFileName | Out-Null


##Functions----------------------------------------------------------------------------

#software Info Card
function show_intro_card(){

    # Program Header
    Write-Host " -------------------------------------------- " -ForegroundColor DarkRed
    Write-Host "               Youtube Downloader             " -ForegroundColor White
    Write-Host "                 v 0.0.4 By ND                " -ForegroundColor Red
    Write-Host " -------------------------------------------- " -ForegroundColor DarkRed
}

#Video Info Card
function show_video_info_card($jsonInfo){
    ##Display Video Related MetaData Information
    ##===============================================================================
    Write-Host "`n******  Video Info  *******" -ForegroundColor Yellow
    Write-Host "Channel: " -NoNewline
    Write-Host $jsonInfo.uploader -ForegroundColor green


    Write-Host "Title: " -NoNewline
    Write-Host $jsonInfo.title -ForegroundColor Green


    Write-Host "Date: " -NoNewline
    Write-Host $jsonInfo.upload_date -NoNewline  -ForegroundColor Green

    Write-Host "`t" -NoNewline
    Write-Host "Views: " -NoNewline
    Write-Host $jsonInfo.view_count -NoNewline -ForegroundColor Green

    Write-Host "`t" -NoNewline
    Write-Host "Likes: " -NoNewline
    Write-Host $jsonInfo.like_count -NoNewline -ForegroundColor Green

    Write-Host "`t" -NoNewline
    Write-Host "Dislikes: " -NoNewline
    Write-Host $jsonInfo.dislike_count -NoNewline -ForegroundColor Green
    Write-Host "`n"
    ##===========================================================================
}


# to be noted info card
function show_to_be_noted_info_card() {
    ##Display Static To be noted Info
    ##===============================================================================
    Write-Host "`n"
    Write-Host "******  To be Noted  *******" -ForegroundColor Red
    Write-Host "tiny: " -NoNewline
    Write-Host "audioFiles" -ForegroundColor Yellow


    Write-Host "format_id (18,22): " -NoNewline
    Write-Host "audio-video-combined" -ForegroundColor Yellow
    ##=================================================================================
}


# video resolution table
function show_video_res_table($jsonInfo){

    ##Display Video Format Info Table
    ##=================================================================================
    Write-Host "`n"
    Write-Host "******  Video Format Info  *******" -ForegroundColor Cyan
    ##$jsonInfo.formats | Select-Object -Wait -Property format_id, format_note, ext, filesize, vcodec, acodec, fps ,format | Format-Table

    $jsonInfo.formats | Select-Object -Wait -Property @{N='FORMAT ID';E={$_.format_id}}, @{N='RESOLUTION';E={$_.format_note}}, @{N='EXTENSION';E={$_.ext}}, @{N='FILE SIZE';E={$_.filesize}}, @{N='VIDEO CODEC';E={$_.vcodec}}, @{N='AUDIO CODEC';E={$_.acodec}}, @{N='FRAMES PER SEC';E={$_.fps}}, @{N='SUMMARY';E={$_.format}}| Format-Table

    ##===================================================================================

}


#intro user choice 
function get_intro_choice() {

    Write-Host ""
    Write-Host "======" 
    Write-Host " Menu " -ForegroundColor Cyan
    Write-Host "======"
    

    Write-Host "[1] New Video Download / Link" -ForegroundColor Yellow
    Write-Host "[0] Exit" -ForegroundColor Yellow

    [int]$choice = Read-Host -Prompt "`nEnter your choice [0-1]"

    return $choice
    
}


function handle_program_intro() {
    show_intro_card

    [int]$choice = 0

    while($true){

        $choice = get_intro_choice

        if($choice -lt 0 -OR $choice -gt 1){
            Write-Host "`nInvalid Input! Try Again" -ForegroundColor Red
            continue
        }else {
            break
        }

    }

    if($choice -eq 0){
        Clear-Host
        exit
    }

    return $choice
}

function handle_get_input_link(){

    Clear-Host
    show_intro_card

    [string]$link

    while($true){
        $link = Read-Host -Prompt "`nEnter the youtube video url `n"
        
        if(isYotubeLinkValid($link)){
            break
        }else {
            Write-Host "`nInvalid Link! Please Try Again" -ForegroundColor Red
            continue
        }
    }

    return $link
}


function isYotubeLinkValid($link){
    return $link -match '^(http(s)?:\/\/)?((w){3}.)?youtu(be|.be)?(\.com)?\/.+'
}

function show_choice_menu(){

    Write-Host "`n"
    Write-Host "=================" 
    Write-Host "Download Choice" -ForegroundColor Cyan
    Write-Host "================="
    

    Write-Host "[1] Download Single File" -ForegroundColor Yellow
    Write-Host "[2] Download Separate Audio and video Files" -ForegroundColor Yellow
    Write-Host "[3] Download best Quality Audio File" -ForegroundColor Yellow
    Write-Host "[4] Download the best Quality Video File" -ForegroundColor Yellow
    Write-Host "[5] Download the best quality audio and video file" -ForegroundColor Yellow
    Write-Host "[6] Exit" -ForegroundColor Yellow

    [int]$choice = Read-Host -Prompt "`nEnter your choice [1-6]"

    return $choice
}

function get_user_input_downloadPreference(){

    [int]$downloadChoice = 0

    while($true){
        $downloadChoice = show_choice_menu
    
        if($downloadChoice -lt 1 -OR $downloadChoice -gt 6){
            Write-Host "`nInvalid Input! Try Again" -ForegroundColor Red
            continue
        }else{
            break
        }
    }
    
    if($downloadChoice -eq 6){
        Pause
    }

    return $downloadChoice
}

function show_output_choice(){

    Write-Host "`n"
    Write-Host "================="
    Write-Host "Display Choice" -ForegroundColor Cyan
    Write-Host "================="
 

    Write-Host "[1] Show Link on screen" -ForegroundColor Yellow
    Write-Host "[2] Save Link to File" -ForegroundColor Yellow
    Write-Host "[3] Download Video" -ForegroundColor Yellow
    Write-Host "[4] Play in VLC" -ForegroundColor Yellow
    Write-Host "[5] Exit" -ForegroundColor Yellow

    [int]$choice = Read-Host -Prompt "`nEnter your choice [1-4]"

    return $choice
}


function get_user_input_displayPreference(){

    [int]$displayChoice = 0

    while($true){
        $displayChoice = show_output_choice
    
        if($displayChoice -lt 1 -OR $displayChoice -gt 5){
            Write-Host "`nInvalid Input! Try Again" -ForegroundColor Red
            continue
        }else{
            break
        }
    }
    
    if($displayChoice -eq 5){
        Pause
    }

    return $displayChoice
}

function updateScreen_onDownload_succeeded(){
    Write-Host "`nFile Download Successful`n" -ForegroundColor Green
    Pause
}

function updateScreen_onLink_Generated(){
    Pause
}

function updateScreen_onLink_savedToFile(){
    Write-Host "`nDownload Link Saved in $outputFileName`n" -ForegroundColor Green
    Pause
}

function updateScreen_Playing_on_vlc(){
    Write-Host "`nPlaying media on vlc.....`n" -ForegroundColor Green
    Pause
}

function updateScreen_Processing_Request(){
    Write-Host "`nProcessing Request. Please Wait....`n" -ForegroundColor Cyan
}

function updateScreen_show_upto_videoInfo($jsonInfo){
    Clear-Host
    show_intro_card
    show_video_info_card($jsonInfo)

}





##Main Script Starts Here --------------------------------------------------------------

Clear-Host

# exit 1 to continue or 0 to exit

[string]$youtubeLink

while ($true) {
    # Clear The Screen
    Clear-Host
    handle_program_intro

    $youtubeLink = handle_get_input_link

    ##Update the screen for user wait message
    Write-Host "`nProcessing....... `n " -ForegroundColor Cyan

    ##Fetch Video meta data from site - convert to json object and store it in and object
    $jsonInfo=.\youtube-dl -j $youtubeLink | ConvertFrom-Json

    # Clear the screen
    Clear-Host

    # Show the intro card
    show_intro_card

    # Display the video info card
    show_video_info_card($jsonInfo)

    # show the to be noted card
    show_to_be_noted_info_card

    # show video resTable
    show_video_res_table($jsonInfo)

    # get download Choice 
    [int]$downloadChoice = get_user_input_downloadPreference

    # get display choice
    [int]$displayChoice = get_user_input_displayPreference



    ##Download Single File
    if($downloadChoice -eq 1){
        [int]$formatId = Read-Host -Prompt "`nEnter desiered format Id"

        updateScreen_show_upto_videoInfo($jsonInfo)
        updateScreen_Processing_Request

        # Download Video File
        if($displayChoice -eq 3){
            Write-Host "`n"
            .\youtube-dl -f $formatId -o $outputDirTemplate $youtubeLink

            updateScreen_onDownload_succeeded
        }

        $singleDownloadLink=.\youtube-dl --get-url -f $formatId $youtubeLink

        # Show Download Link on Screen
        if($displayChoice -eq 1){

            Write-Host "`nDownload Link:" -ForegroundColor Green
            Write-Host "----------------`n" -ForegroundColor Green
            Write-Host $singleDownloadLink
            Write-Host "`n"

            updateScreen_onLink_Generated

        }

        # Save Download Link to File
        if($displayChoice -eq 2){

            $jsonInfo.title | Add-Content $outputFileName
            $jsonInfo.uploader | Add-Content $outputFileName
            Add-Content $outputFileName "`n"
            Add-Content $outputFileName "Download URL: `n"
            $singleDownloadLink | Add-Content $outputFileName

            updateScreen_onLink_savedToFile
        }

        # Play directly in vlc
        if($displayChoice -eq 4){

            Start-Process vlc -ArgumentList "`"$singleDownloadLink`""

            updateScreen_Playing_on_vlc
        }   

    }




    # Download Both Audio and Video Files
    if($downloadChoice -eq 2){

        [int]$videoFormatId = Read-Host -Prompt "`nEnter desiered video format Id"
        [int]$audioFormatId = Read-Host -Prompt "`nEnter desiered audio format Id"

        updateScreen_show_upto_videoInfo($jsonInfo)
        updateScreen_Processing_Request

        # Download Video File
        if($displayChoice -eq 3){
            Write-Host "`n"

            .\youtube-dl -f $videoFormatId+$audioFormatId --merge-output-format mkv -o $outputDirTemplate $youtubeLink

            updateScreen_onDownload_succeeded
        }

        $videoLink=.\youtube-dl --get-url -f $videoFormatId $youtubeLink
        $audioLink=.\youtube-dl --get-url -f $audioFormatId $youtubeLink


        # Display Download Link On Screen
        if($displayChoice -eq 1){
            Write-Host "`nVideo Link:" -ForegroundColor Green
            Write-Host "-------------" -ForegroundColor Green
            Write-Host $videoLink
            

            Write-Host "`nAudio Link:" -ForegroundColor Green
            Write-Host "-------------" -ForegroundColor Green
            Write-Host $audioLink
            Write-Host "`n"

            updateScreen_onLink_Generated
        }

        # Save Download Link to file
        if($displayChoice -eq 2){

            $jsonInfo.title | Add-Content $outputFileName
            $jsonInfo.uploader | Add-Content $outputFileName

            Add-Content $outputFileName "`n"
            Add-Content $outputFileName "Video URL: `n"
            $videoLink | Add-Content $outputFileName

            Add-Content $outputFileName "`n"
            Add-Content $outputFileName "Audio URL: `n"
            $audioLink | Add-Content $outputFileName

            updateScreen_onLink_savedToFile
        }

        # Play directly in vlc
        if($displayChoice -eq 4){

            Start-Process vlc -ArgumentList "`"$videoLink`" --input-slave `"$audioLink`""

            updateScreen_Playing_on_vlc
        }

    
    }


    # Download the best Qulaity Audio File
    if($downloadChoice -eq 3){

        updateScreen_show_upto_videoInfo($jsonInfo)
        updateScreen_Processing_Request

        # Download Audio File
        if($displayChoice -eq 3){
            Write-Host "`n"

            .\youtube-dl -f 'bestaudio' -o $outputDirTemplate $youtubeLink

            updateScreen_onDownload_succeeded
        }

        $audioLink = $jsonInfo.requested_formats[1].url ##Default best audio url

        # Display Download Link on Screen
        if($displayChoice -eq 1){
            
            Write-Host "`nAudio Link:" -ForegroundColor Green
            Write-Host "-------------" -ForegroundColor Green
            Write-Host $audioLink
            Write-Host "`n"

            updateScreen_onLink_Generated
        }

        # Save Link to File
        if($displayChoice -eq 2){
            
            $jsonInfo.title | Add-Content $outputFileName
            $jsonInfo.uploader | Add-Content $outputFileName

            Add-Content $outputFileName "`n"
            Add-Content $outputFileName "Audio URL: `n"
            $audioLink | Add-Content $outputFileName ## Default best Audio URL

            updateScreen_onLink_savedToFile
        }

        # Play directly in vlc
        if($displayChoice -eq 4){

            Start-Process vlc -ArgumentList "`"$audioLink`""

            updateScreen_Playing_on_vlc
        }
    }


    # Download the best Qulaity Video File
    if($downloadChoice -eq 4){
        updateScreen_show_upto_videoInfo($jsonInfo)
        updateScreen_Processing_Request

        # Download Video File
        if($displayChoice -eq 3){
            Write-Host "`n"

            .\youtube-dl -f 'bestvideo' -o $outputDirTemplate $youtubeLink

            updateScreen_onDownload_succeeded
        }

        $videoLink = $jsonInfo.requested_formats[0].url ##Default best video url

        # Display Download Link on Screen
        if($displayChoice -eq 1){
            
            Write-Host "`nVideo Link:" -ForegroundColor Green
            Write-Host "-------------" -ForegroundColor Green
            Write-Host $videoLink
            Write-Host "`n"

            updateScreen_onLink_Generated
        }

        # Save Link to File
        if($displayChoice -eq 2){
            
            $jsonInfo.title | Add-Content $outputFileName
            $jsonInfo.uploader | Add-Content $outputFileName

            Add-Content $outputFileName "`n"
            Add-Content $outputFileName "Video URL: `n"
            $videoLink | Add-Content $outputFileName ## Default best Video URL

            updateScreen_onLink_savedToFile
        }

        # Play directly in vlc
        if($displayChoice -eq 4){

            Start-Process vlc -ArgumentList "`"$videoLink`""

            updateScreen_Playing_on_vlc
        }
    }


    # Download The Best Qulaity Audio and video Files
    if($downloadChoice -eq 5){

        updateScreen_show_upto_videoInfo($jsonInfo)
        updateScreen_Processing_Request

        # Download Video File
        if($displayChoice -eq 3){
            Write-Host "`n"

            .\youtube-dl -f 'bestvideo+bestaudio' -o $outputDirTemplate $youtubeLink

            updateScreen_onDownload_succeeded
        }

        $videoLink=.\youtube-dl --get-url -f 'bestvideo' $youtubeLink
        $audioLink=.\youtube-dl --get-url -f 'bestaudio' $youtubeLink


        # Display Download Link On Screen
        if($displayChoice -eq 1){
            Write-Host "`nVideo Link:" -ForegroundColor Green
            Write-Host "-------------" -ForegroundColor Green
            Write-Host $videoLink
            

            Write-Host "`nAudio Link:" -ForegroundColor Green
            Write-Host "-------------" -ForegroundColor Green
            Write-Host $audioLink
            Write-Host "`n"

            updateScreen_onLink_Generated
        }

        # Save Download Link to file
        if($displayChoice -eq 2){

            $jsonInfo.title | Add-Content $outputFileName
            $jsonInfo.uploader | Add-Content $outputFileName

            Add-Content $outputFileName "`n"
            Add-Content $outputFileName "Video URL: `n"
            $videoLink | Add-Content $outputFileName

            Add-Content $outputFileName "`n"
            Add-Content $outputFileName "Audio URL: `n"
            $audioLink | Add-Content $outputFileName

            updateScreen_onLink_savedToFile
        }

        # Play directly in vlc
        if($displayChoice -eq 4){

            Start-Process vlc -ArgumentList "`"$videoLink`" --input-slave `"$audioLink`""

            updateScreen_Playing_on_vlc
        }
    
    }

}

    