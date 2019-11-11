function Controller() {
    installer.setDefaultPageVisible(QInstaller.Introduction, false);
    installer.setDefaultPageVisible(QInstaller.TargetDirectory, false);
    installer.setDefaultPageVisible(QInstaller.ComponentSelection, false);
    installer.setDefaultPageVisible(QInstaller.LicenseCheck, false);
    installer.setDefaultPageVisible(QInstaller.StartMenuSelection, false);
    installer.setDefaultPageVisible(QInstaller.ReadyForInstallation, false);
    installer.setDefaultPageVisible(QInstaller.PerformInstallation, false);
    gui.setSilent(true);
    installer.autoRejectMessageBoxes();

    var page = gui.pageWidgetByObjectName("WelcomePage");
    page.completeChanged.connect(welcomepageFinished);
}

welcomepageFinished = function()
{
    //completeChange() -function is called also when other pages visible
    //Make sure that next button is clicked only when in welcome page
    if(gui.currentPageWidget().objectName == "WelcomePage") {
        gui.clickButton( buttons.NextButton);   
    }
}

Controller.prototype.WelcomePageCallback = function() {
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.CredentialsPageCallback = function() {
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.IntroductionPageCallback = function() {
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.TargetDirectoryPageCallback = function()
{
    gui.currentPageWidget().TargetDirectoryLineEdit.setText("/opt/Qt");
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.ComponentSelectionPageCallback = function() {
    var widget = gui.currentPageWidget();

    //widget.selectAll();
    //widget.deselectComponent('qt.597.src');

    widget.deselectAll();
    widget.selectComponent("qt.597.gcc_64");
    // // widget.selectComponent("qt.597.doc")
    // // widget.selectComponent("qt.597.examples")
    // widget.selectComponent("qt.597.qtcharts")
    // widget.selectComponent("qt.597.qtcharts.gcc_64")
    // widget.selectComponent("qt.597.qtdatavis3d")
    // widget.selectComponent("qt.597.qtdatavis3d.gcc_64")
    // widget.selectComponent("qt.597.qtnetworkauth")
    // widget.selectComponent("qt.597.qtnetworkauth.gcc_64")
    // widget.selectComponent("qt.597.qtpurchasing")
    // widget.selectComponent("qt.597.qtpurchasing.gcc_64")
    // widget.selectComponent("qt.597.qtremoteobjects")
    // widget.selectComponent("qt.597.qtremoteobjects.gcc_64")
    // widget.selectComponent("qt.597.qtscript")
    // widget.selectComponent("qt.597.qtspeech")
    // widget.selectComponent("qt.597.qtspeech.gcc_64")
    // widget.selectComponent("qt.597.qtvirtualkeyboard")
    // widget.selectComponent("qt.597.qtvirtualkeyboard.gcc_64")
    // widget.selectComponent("qt.597.qtwebengine")
    // widget.selectComponent("qt.597.qtwebengine.gcc_64")
    // // widget.selectComponent("qt.597.src")
    // widget.selectComponent("qt.tools.qtcreator")

    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.LicenseAgreementPageCallback = function() {
    gui.currentPageWidget().AcceptLicenseRadioButton.setChecked(true);
    gui.clickButton(buttons.NextButton, 10000);
}

Controller.prototype.StartMenuDirectoryPageCallback = function() {
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.ReadyForInstallationPageCallback = function()
{
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.FinishedPageCallback = function() {
var checkBoxForm = gui.currentPageWidget().LaunchQtCreatorCheckBoxForm
if (checkBoxForm && checkBoxForm.launchQtCreatorCheckBox) {
    checkBoxForm.launchQtCreatorCheckBox.checked = false;
}
    gui.clickButton(buttons.FinishButton);
}
