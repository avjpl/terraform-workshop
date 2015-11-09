Hi there,

Thank you for downloading the Terraform tutorial materials! Please complete the
steps documented here to best prepare yourself for the workshop.

Because the WiFi at venues is often unpredictable, please download and
install the latest version of Terraform for your operating system beforehand.

Please do NOT install Terraform using your system package manager, as it is
likely to be outdated. Instead, please download Terraform from:

    https://j.mp/tfget

This will take you to the official Terraform downloads page. Once there, select
the version of Terraform that best suits your operating system.

Terraform will download as a ZIP archive. Extract this archive and put it in
your $PATH. For help on adding things to your system PATH, please see the
following articles:

    - Windows: https://stackoverflow.com/questions/19287379/how-do-i-add-to-the-windows-path-variable-using-setx-having-weird-problems
    - OSX/Linxus: https://stackoverflow.com/questions/14637979/how-to-permanently-set-path-on-linux

On Windows. you will need to run Powershell as an Administrator. On other OSes,
you can run your terminal program as-is.

You can check if Terraform is working and in your path by running:

    $ terraform -version

from the terminal. You should get a version number back. If you get an error,
please repeat the installation steps.

- - -

Next, sign up for an Amazon Web Services (AWS) account. We will use AWS to
provision resources, but you could use any cloud provider. We chose AWS because
it is very common and easily adaptable to other cloud options.

The steps for creating an AWS account are in this folder in the
"AWS Sign Up.pdf". Please follow these steps and verify your account is working.

- - -

That's it! You are ready for the tutorial! If you have any questions, please
feel free to contact me at seth@hashicorp.com.

Best,
Seth
