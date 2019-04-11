function Email {
    [CmdLetBinding(SupportsShouldProcess = $True)]
    param(
        [Parameter(Mandatory = $false, Position = 0)][ScriptBlock] $Email,
        [string[]] $To,
        [string[]] $CC,
        [string[]] $BCC,
        [string] $ReplyTo,
        [string] $From,
        [string] $Subject,
        [alias('SelfAttach')][switch] $AttachSelf,
        [string] $AttachSelfName,
        [string] $Server,
        [string] $Username,
        [int] $Port = 587,
        [string] $Password,
        [switch] $PasswordFromFile,
        [switch] $PasswordAsSecure,
        [switch] $SSL,
        [ValidateSet('Low', 'Normal', 'High')] [string] $Priority = 'Normal',
        [ValidateSet('None', 'OnSuccess', 'OnFailure', 'Delay', 'Never')] $DeliveryNotifications = 'None',
        [string] $Encoding = 'Unicode',
        [string] $FilePath,
        [bool] $Supress = $true
    )
    $StartTime = Start-TimeLog
    $ServerParameters = [ordered] @{
        From                  = $From
        To                    = $To
        CC                    = $CC
        BCC                   = $BCC
        ReplyTo               = $ReplyTo
        Server                = $Server
        Login                 = $Username
        Password              = $Password
        PasswordAsSecure      = $PasswordAsSecure
        PasswordFromFile      = $PasswordFromFile
        Port                  = $Port

        EnableSSL             = $SSL
        Encoding              = $Encoding
        Subject               = $Subject
        Priority              = $Priority
        DeliveryNotifications = $DeliveryNotifications
    }
    $Attachments = [System.Collections.Generic.List[string]]::new()
    $Body = New-HTML -UseCssLinks -UseJavaScriptLinks {
        [Array] $EmailParameters = Invoke-Command -ScriptBlock $Email

        #New-HTML -FilePath 'C:\Users\przemyslaw.klys\OneDrive - Evotec\Support\GitHub\Emailimo\Examples\Temp.html' -UseCssLinks -UseJavaScriptLinks {
        foreach ($Parameter in $EmailParameters) {
            switch ( $Parameter.Type ) {
                HeaderTo {
                    $ServerParameters.To = $Parameter.Addresses
                }
                HeaderCC {
                    $ServerParameters.CC = $Parameter.Addresses
                }
                HeaderBCC {
                    $ServerParameters.BCC = $Parameter.Addresses
                }
                HeaderFrom {
                    $ServerParameters.From = $Parameter.Address
                }
                HeaderReplyTo {
                    $ServerParameters.ReplyTo = $Parameter.Address
                }
                HeaderSubject {
                    $ServerParameters.Subject = $Parameter.Subject
                }
                HeaderServer {
                    $ServerParameters.Server = $Parameter.Server
                    $ServerParameters.Port = $Parameter.Port
                    $ServerParameters.Login = $Parameter.UserName
                    $ServerParameters.Password = $Parameter.Password
                    $ServerParameters.PasswordFromFile = $Parameter.PasswordFromFile
                    $ServerParameters.PasswordAsSecure = $Parameter.PasswordAsSecure
                    $ServerParameters.EnableSSL = $Parameter.SSL
                }
                HeaderAttachment {
                    $Attachments.Add($Parameter.FilePath)
                }
                HeaderOptions {
                    $ServerParameters.DeliveryNotifications = $Parameter.DeliveryNotifications
                    $ServerParameters.Encoding = $Parameter.Encoding
                    $ServerParameters.Priority = $Parameter.Priority
                }
                Default {
                    $Parameter
                }
            }
        }
    }
    if ($FilePath) {
        Save-HTML -FilePath $FilePath -HTML $Body
    }
    if ($AttachSelf) {
        if ($AttachSelfName) {
            $TempFilePath = "$(Get-TemporaryDirectory)\$($AttachSelfName).html"
        } else {
            $TempFilePath = ''
        }
        $Saved = Save-HTML -FilePath $TempFilePath -HTML $Body -Supress $false
        if ($Saved) {
            $Attachments.Add($Saved)
        }
    }

    $MailSentTo = "To: $($ServerParameters.To -join ', '); CC: $($ServerParameters.CC -join ', '); BCC: $($ServerParameters.BCC -join ', ')".Trim()
    if ($pscmdlet.ShouldProcess("$MailSentTo", "Email")) {
        $EmailOutput = Send-Email -EmailParameters $ServerParameters -Body ($Body -join '') -Attachment $Attachments -Verbose
        if (-not $Supress) {
            $EmailOutput
        }
    }
    $EndTime = Stop-TimeLog -Time $StartTime -Option OneLiner
    Write-Verbose "Email - Time to send: $EndTime"
}