<#
    Script to remove many of the pre-loaded Microsoft Metro "modern app" bloatware.
    Adapted from https://github.com/bmrf/tron
#>

$ErrorActionPreference = "Continue"

# Removal function
Function Remove-App([String]$AppName){
	echo "$AppName"
	Get-AppxPackage -AllUsers -Name $AppName | Remove-AppxPackage -AllUsers
	Get-AppxProvisionedPackage -Online | where {$_.Displayname -like $AppName} | Remove-AppxProvisionedPackage -Online -AllUsers
}

Remove-App "89006A2E.AutodeskSketchBook"
Remove-App "A278AB0D.DisneyMagicKingdoms"
Remove-App "A278AB0D.MarchofEmpires"
Remove-App "DolbyLaboratories.DolbyAccess"
Remove-App "king.com.BubbleWitch3Saga"
Remove-App "king.com.CandyCrushSodaSaga"
Remove-App "Microsoft.3DBuilder"                       # 3DBuilder app
Remove-App "Microsoft.Advertising*"                    # Advertising framework
Remove-App "Microsoft.Advertising.Xaml"  #removal fails, multiple entries with this name
Remove-App "Microsoft.Appconnector"                   # Not sure about this one
Remove-App "Microsoft.BingFinance"                     # Money app - Financial news
Remove-App "Microsoft.BingFoodAndDrink"                # Food and Drink app
Remove-App "Microsoft.BingHealthAndFitness"            # Health and Fitness app
Remove-App "Microsoft.BingNews"                        # Generic news app
Remove-App "Microsoft.BingSports"                      # Sports app - Sports news
Remove-App "Microsoft.BingTranslator"                  # Translator app - Bing Translate
Remove-App "Microsoft.BingTravel"                      # Travel app
Remove-App "Microsoft.BingWeather"                    # Weather app
Remove-App "Microsoft.CommsPhone"                      # Phone app
Remove-App "Microsoft.ConnectivityStore"
Remove-App "Microsoft.DesktopAppInstaller"
Remove-App "Microsoft.FreshPaint"                      # Canvas app
Remove-App "Microsoft.GetHelp"                         # Get Help link
Remove-App "Microsoft.Getstarted"                      # Get Started link
Remove-App "Microsoft.Messaging"                       # Messaging app
Remove-App "Microsoft.Microsoft3DViewer"              # 3D model viewer
Remove-App "Microsoft.MicrosoftJackpot"                # Jackpot app
Remove-App "Microsoft.MicrosoftJigsaw"                 # Jigsaw app
Remove-App "Microsoft.MicrosoftOfficeHub"
Remove-App "Microsoft.MicrosoftPowerBIForWindows"      # Power BI app - Business analytics
Remove-App "Microsoft.MicrosoftSolitaireCollection"   # Solitaire collection
Remove-App "Microsoft.MicrosoftStickyNotes"           # Sticky notes phone home
Remove-App "Microsoft.MicrosoftSudoku"
Remove-App "Microsoft.MinecraftUWP"
Remove-App "Microsoft.MovieMoments"                    # imported from stage_2_de-bloat.bat
Remove-App "Microsoft.MSPaint"                        # MS Paint (Paint 3D)
Remove-App "Microsoft.NetworkSpeedTest"
Remove-App "Microsoft.Office.OneNote"                  # Onenote app
Remove-App "Microsoft.Office.Sway"                     # Sway app
Remove-App "Microsoft.OneConnect"                      # OneConnect app
Remove-App "Microsoft.People"                          # People app
Remove-App "Microsoft.Print3D"
Remove-App "Microsoft.Services.Store.Engagement" #removal fails, multiple entries with this name
Remove-App "Microsoft.SkypeApp"                        # Get Skype link
Remove-App "Microsoft.SkypeWiFi"
Remove-App "Microsoft.StorePurchaseApp"
Remove-App "Microsoft.Studios.Wordament"               # imported from stage_2_de-bloat.bat
Remove-App "Microsoft.Wallet"
Remove-App "Microsoft.WindowsAlarms"                  # Alarms and Clock app
Remove-App "Microsoft.WindowsCalculator"              # Calculator app
Remove-App "Microsoft.WindowsCamera"                  # Camera app
Remove-App "Microsoft.windowscommunicationsapps"      # Calendar and Mail app
Remove-App "Microsoft.WindowsFeedbackHub"              # Feedback app
Remove-App "Microsoft.WindowsMaps"                    # Maps app
Remove-App "Microsoft.Windows.Photos"                 # Photos app
Remove-App "Microsoft.WindowsReadingList*"
Remove-App "Microsoft.WindowsSoundRecorder"           # Sound Recorder app
Remove-App "Microsoft.WindowsStore"                   # Windows Store
Remove-App "Microsoft.XboxApp"
Remove-App "Microsoft.XboxGameCallableUI"
Remove-App "Microsoft.XboxGameOverlay"
Remove-App "Microsoft.XboxIdentityProvider"
Remove-App "Microsoft.XboxSpeechToTextOverlay"
Remove-App "Microsoft.Xbox.TCUI"
Remove-App "Microsoft.ZuneMusic"
Remove-App "Microsoft.ZuneVideo"
Remove-App "SpotifyAB.SpotifyMusic"



#Remove-App "Microsoft.AAD.BrokerPlugin" #unremovable
#Remove-App "Microsoft.AccountsControl" #unremovable
#Remove-App "Microsoft.BioEnrollment" #unremovable
#Remove-App "Microsoft.CredDialogHost" #unremovable
#Remove-App "Microsoft.ECApp" #unremovable
#Remove-App "Microsoft.PPIProjection" #unremovable
#Remove-App "Microsoft.Windows.Apprep.ChxApp" #unremovable
#Remove-App "Microsoft.Windows.AssignedAccessLockApp" #unremovable
#Remove-App "Microsoft.Windows.CloudExperienceHost" #unremovable
#Remove-App "Microsoft.Windows.ContentDeliveryManager" #unremovable
#Remove-App "Microsoft.Windows.Cortana" #unremovable
#Remove-App "Microsoft.Windows.HolographicFirstRun" #unremovable
#Remove-App "Microsoft.Windows.OOBENetworkCaptivePortal" #unremovable
#Remove-App "Microsoft.Windows.OOBENetworkConnectionFlow" #unremovable
#Remove-App "Microsoft.Windows.ParentalControls" #unremovable
#Remove-App "Microsoft.Windows.PeopleExperienceHost" #unremovable
#Remove-App "Microsoft.XboxGameCallableUI" #unremovable

