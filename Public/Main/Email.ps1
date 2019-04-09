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
        [switch] $AttachSelf,
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
        [string] $FilePath
    )
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
                HeaderServer {
                    $ServerParameters.Server = $Parameter.Server
                    $ServerParameters.Login = $Parameter.UserName
                    $ServerParameters.Password = $Parameter.Password
                    $ServerParameters.Port = $Parameter.Port
                    $ServerParameters.EnableSSL = $Parameter.SSL
                    $ServerParameters.PasswordFromFile = $false
                    $ServerParameters.PasswordAsSecure = $false
                }
                HeaderAttachment {
                    #$ServerParameters.EmailTo = $Parameter.Addresses
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
    $MailSentTo = "To: $($ServerParameters.To -join ', '); CC: $($ServerParameters.CC -join ', '); BCC: $($ServerParameters.BCC -join ', ')".Trim()
    if ($pscmdlet.ShouldProcess("$MailSentTo", "Email")) {
        Send-Email -EmailParameters $ServerParameters -Body ($Body -join '') -Verbose
    }
}