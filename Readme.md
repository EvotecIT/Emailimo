<p align="center">
  <a href="https://www.powershellgallery.com/packages/Emailimo"><img src="https://img.shields.io/powershellgallery/v/Emailimo.svg"></a>
  <a href="https://www.powershellgallery.com/packages/Emailimo"><img src="https://img.shields.io/powershellgallery/vpre/Emailimo.svg?label=powershell%20gallery%20preview&colorB=yellow"></a>
  <a href="https://github.com/EvotecIT/Emailimo"><img src="https://img.shields.io/github/license/EvotecIT/Emailimo.svg"></a>
</p>

<p align="center">
  <a href="https://www.powershellgallery.com/packages/Emailimo"><img src="https://img.shields.io/powershellgallery/p/Emailimo.svg"></a>
  <a href="https://github.com/EvotecIT/Emailimo"><img src="https://img.shields.io/github/languages/top/evotecit/Emailimo.svg"></a>
  <a href="https://github.com/EvotecIT/Emailimo"><img src="https://img.shields.io/github/languages/code-size/evotecit/Emailimo.svg"></a>
  <a href="https://github.com/EvotecIT/Emailimo"><img src="https://img.shields.io/powershellgallery/dt/Emailimo.svg"></a>
</p>

<p align="center">
  <a href="https://twitter.com/PrzemyslawKlys"><img src="https://img.shields.io/twitter/follow/PrzemyslawKlys.svg?label=Twitter%20%40PrzemyslawKlys&style=social"></a>
  <a href="https://evotec.xyz/hub"><img src="https://img.shields.io/badge/Blog-evotec.xyz-2A6496.svg"></a>
  <a href="https://www.linkedin.com/in/pklys"><img src="https://img.shields.io/badge/LinkedIn-pklys-0077B5.svg?logo=LinkedIn"></a>
</p>

# Emailimo - PowerShell Module

**Emailimo** is simplified **PowerShell** module allowing to send emails using english like syntax. It provides easy to use commands that allow you to sort of tyupe your email like you would in Outlook (to some extent - it's still **PowerShell** you know!). Emailimo is based on [PSWriteHTML](https://github.com/EvotecIT/PSWriteHTML).

### Changelog

- 0.0.7 - 2019.06.17
  - Support for new PSWriteHTML

- 0.0.6 - 2019.06.02
  - Fix for EmailListItem for multiple texts

- 0.0.2 to 0.0.5
  - Something important but forgot what

- 0.0.1 - 2019.04.12
  - First public release
  - Overview: https://evotec.xyz/meet-emailimo-new-way-to-send-pretty-emails-with-powershell/


#### Example 1

```
Email -WhatIf {
    EmailHeader {
        EmailFrom -Address 'reminder@domain.pl'
        EmailTo -Addresses "przemyslaw.klys@domain.pl"
        EmailServer -Server 'mail.evotec.com' -UserName 'UserName' -Password 'C:\Support\Important\Password-Evotec-Reminder.txt' -PasswordAsSecure -PasswordFromFile
        EmailOptions -Priority High -DeliveryNotifications Never
        EmailSubject -Subject 'This is a test email'
    }
    EmailBody -FontFamily 'Calibri' -Size 15 {
        EmailText -Text "Hello ", $UserNotify, "," -Color None, Blue, None -Verbose -LineBreak
        EmailText -Text "Your password is due to expire in ", $PasswordExpiryDays, "days." -Color None, Green, None
        EmailText -LineBreak
        EmailText -Text 'To change your password: '
        EmailText -Text '- press ', 'CTRL+ALT+DEL', ' -> ', 'Change a password...' -Color None, BlueViolet, None, Red
        EmailText -LineBreak
        EmailTextBox {
            'If you have forgotten your password and need to reset it, you can do this by clicking here. '
            "In case of problems please contact the HelpDesk by visiting [Evotec Website](https://evotec.xyz) or by sending an email to Help Desk."
        }
        EmailText -LineBreak
        EmailText -Text 'Alternatively you can always call ', 'Help Desk', ' at ', '+48 22 00 00 00' `
            -Color None, LightSkyBlue, None, LightSkyBlue -TextDecoration none, underline, none, underline -FontWeight normal, bold, normal, bold
        EmailText -LineBreak
        EmailTextBox {
            'Kind regards,'
            'Evotec IT'
        }
    }
}
```

![Example 1](https://evotec.xyz/wp-content/uploads/2019/04/img_5cafac409c12b.png)


#### Example 2

```
Email -WhatIf {
    EmailHeader {
        EmailFrom -Address 'reminder@domain.pl'
        EmailTo -Addresses "przemyslaw.klys@domain.pl"
        EmailServer -Server 'mail.evotec.com' -UserName 'UserName' -Password 'C:\Support\Important\Password-Evotec-Reminder.txt' -PasswordAsSecure -PasswordFromFile
        EmailOptions -Priority High -DeliveryNotifications Never
        EmailSubject -Subject 'This is a test email'
    }
    EmailBody -FontFamily 'Calibri' -Size 15 {
        EmailText -Text "Hello ", $UserNotify, "," -Color None, Blue, None -Verbose -LineBreak
        EmailText -Text "Your password is due to expire in ", $PasswordExpiryDays, "days." -Color None, Green, None
        EmailText -LineBreak
        EmailText -Text 'To change your password: '
        EmailText -Text '- press ', 'CTRL+ALT+DEL', ' -> ', 'Change a password...' -Color None, BlueViolet, None, Red
        EmailText -LineBreak
        EmailTextBox {
            'If you have forgotten your password and need to reset it, you can do this by clicking here. '
            "In case of problems please contact the HelpDesk by visiting [Evotec Website](https://evotec.xyz) or by sending an email to Help Desk."
        }
        EmailText -LineBreak
        EmailText -Text 'Alternatively you can always call ', 'Help Desk', ' at ', '+48 22 00 00 00' `
            -Color None, LightSkyBlue, None, LightSkyBlue -TextDecoration none, underline, none, underline -FontWeight normal, bold, normal, bold
        EmailText -LineBreak
        EmailTextBox {
            'Kind regards,'
            'Evotec IT'
        }
    }
}
```

![Example 2](https://evotec.xyz/wp-content/uploads/2019/04/img_5cafaf30eaed5.png)

#### Example 3

```
if ($null -eq $Table) {
    $Table = (Get-Process | Select-Object -First 5 -Property Name, BasePriority, Company, CompanyName)
}
if ($null -eq $Table1) {
    $Table1 = (Get-ChildItem | Select-Object -First 5)
}

Email -AttachSelf -AttachSelfName 'My report' {
    EmailHeader {
        EmailFrom -Address 'reminder@domain.pl'
        EmailTo -Addresses "przemyslaw.klys@domain.pl"
        EmailCC -Addresses "przemyslaw.klys@domain.pl"
        EmailBCC -Addresses "kontakt@domain.pl"
        EmailServer -Server 'mail.domain.pl' -UserName 'UserName' -Password 'C:\Support\Important\Password-Evotec-Reminder.txt' -PasswordAsSecure -PasswordFromFile
        EmailOptions -Priority Low
        EmailSubject -Subject 'This is a test email'
    }
    EmailBody {

        EmailTextBox -FontFamily 'Calibri' -Size 17 -TextDecoration underline -Color DarkSalmon -Alignment center {
            'Demonstration'
        }
        EmailText -LineBreak
        EmailTextBox -FontFamily 'Calibri' -Size 15 {
            "This is some text that's preformatted with Emoji 🤷 ‍️"
            "Adding more text, notice ths should be on next line"
            ""
            "Empty line above will cause a blank space. If you want to continue writting like you would do in normal email please use here strings as seen below."
            @"
                This is tricky but it works like one ❤
                big line... even thou we've split this over few lines
                already this will be one continues line. Get it right? 😎
"@
            ""
        }
        EmailTable -Table $Table
        EmailTextBox -FontSize 15 -Color DarkCyan -FontStyle italic {
            ""
            @"
                This is tricky 😁 but it works like one
                big line... even thou we've split this over few lines
                already this will be one continues line. Get it right?
                Notice how I gave it color and made it font size 15.
"@
            ""
        }
        EmailList -FontSize 15 {
            EmailListItem -Text 'First item' -Color Red
            EmailListItem -Text '2nd item' -Color Green
            EmailList {
                EmailListItem -Text '3rd item' -FontStyle italic
                EmailListItem -Text '4th item' -TextDecoration line-through
            }
        }

        EmailTable -Table $Table1
        EmailText -LineBreak
        EmailText -FontSize 15 -Text 'This is my', 'text' -Color Red, Green -TextDecoration underline -FontFamily 'Calibri'
        EmailText -LineBreak
        EmailText -FontSize 15 -Text 'This is my', 'text', ' but ', ' with different formatting.' -Color Blue, Red, Green -TextDecoration underline, none, 'line-through' -FontFamily 'Calibri'

        EmailText -LineBreak
    }
}
```

![Example 3](https://evotec.xyz/wp-content/uploads/2019/04/img_5cafbfe051735.png)