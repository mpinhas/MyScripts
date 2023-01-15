# Import the Windows Forms module
Add-Type -AssemblyName System.Windows.Forms

# Create a new form
$form = New-Object System.Windows.Forms.Form

# Set the form properties
$form.Width = 350
$form.Height = 270
$form.Text = "Ping Status"

# Create a list box to display the computer status
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Width = 320
$listBox.Height = 160
$listBox.Location = New-Object System.Drawing.Point(10, 10)
$form.Controls.Add($listBox)

# Create a Check Again button
$checkAgainButton = New-Object System.Windows.Forms.Button
$checkAgainButton.Width = 100
$checkAgainButton.Height = 50
$checkAgainButton.Text = "Check Wallbaors"
$checkAgainButton.Location = New-Object System.Drawing.Point(95, 170)
$form.Controls.Add($checkAgainButton)

# Define the list of computers to ping
$computers = "Computer1","Computer2", "Computer3"

# Define the function for the button click event
$checkAgainButton.Add_Click({
    # Clear the list box before adding new items
    $listBox.Items.Clear()
    # Loop through the list of computers and ping each one
    foreach ($computer in $computers) {
        if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
            # Add the computer to the list box with online status
            $listBox.Items.Add("$computer is Online")
        } else {
            # Add the computer to the list box with offline status
            $listBox.Items.Add("$computer IS OFFLINE!!!")
        }
    }
})

# Show the form
$form.ShowDialog()
