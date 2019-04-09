function Email {
    [CmdLetBinding(SupportsShouldProcess = $True)]
    param(
        [Parameter(Mandatory = $false, Position = 0)][ScriptBlock] $Email,
        [string[]] $To,
        [string[]] $CC,
        [string[]] $BCC,
        [string] $From,
        [string] $Subject,
        [switch] $AttachSelf,
        [string] $Server,
        [string] $Username,
        [SecureString] $Password,
        [string] $FilePath
    )


    [Array] $EmailParameters = Invoke-Command -ScriptBlock $Email

    $ServerParameters = [ordered] @{
        #From                  = "reminder@euvic.pl"
        #To                    = ''
        #CC                    = ''
        #BCC                   = ''
        #ReplyTo               = ''
        #Server                = ""
        #Login           = ""
        #Password        = '01000000d08c9ddf0115d1118c7a00c04fc297eb0100000007ebdd2ac1756a40adae7c8dd74c45670000000002000000000003660000c000000010000000f14f9ec55ebf48c4ae741bb5cf0efd3a0000000004800000a0000000100000006d22978809cc19c5042436658970c3b930000000cd617d4dcca88d8962b5c587ec0c94c5923982bc58f9a251e7fd1ce98739d8a9fef11ded119c6838cb16263fa0763ff0140000007057eafbae8df433fc4bcabaa296f6ffc4afc545'
        #Password         = 'C:\Support\Important\Password-Euvic-Reminder.txt' #
        #Password        = ''
        #PasswordAsSecure = $true
        #PasswordFromFile = $false
        #Port            = ''

        #EnableSSL       = 1
        #Encoding              = "Unicode"
        #Subject               = ""
        #Priority              = "Normal"
        #DeliveryNotifications = 'None'  # OnSuccess, OnFailure, Delay, Never
    }

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
        }
    }
    #New-HTML -FilePath 'C:\Users\przemyslaw.klys\OneDrive - Evotec\Support\GitHub\Emailimo\Examples\Temp.html' -UseCssLinks -UseJavaScriptLinks {
    $Body = New-HTML -UseCssLinks -UseJavaScriptLinks {
        foreach ($Parameter in $EmailParameters) {
            switch ( $Parameter.Type ) {
                EmailText {
                    $newHTMLTextSplat = $Parameter.Data
                    New-HTMLText @newHTMLTextSplat
                }
                EmailTable {
                    $newHTMLTableSplat = $Parameter.Data
                    New-HTMLTable @newHTMLTableSplat
                }
                EmailHTML {
                    # Just return HTML
                    $Parameter.HTML
                }
                EmailList {
                    New-HTMLList -Type $Type {
                        Invoke-Command -ScriptBlock $ListItems
                    }
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