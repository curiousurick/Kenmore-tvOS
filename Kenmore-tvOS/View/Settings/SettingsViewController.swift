//  Copyright © 2023 George Urick
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import Kenmore_Models
import Kenmore_Utilities
import Kenmore_DataStores
import Kenmore_Operations

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let logger = Log4S()
    private let appWiper: AppCleaner = AppCleanerImpl()
    private let logoutOperation = OperationManagerImpl.instance.logoutOperation
    private let changeResolutionRow = 0
    private let logoutRow = 1
    private let totalSettingRows = 2
    private let cellIdentifier = "SettingRowCell"

    @IBOutlet var tableView: UITableView!

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if indexPath.row == changeResolutionRow {
            cell.textLabel?.text = "Default Quality Video Level"
        }
        else if indexPath.row == logoutRow {
            cell.textLabel?.text = "Logout"
        }

        return cell
    }

    func numberOfSections(in _: UITableView) -> Int {
        1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        totalSettingRows
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == changeResolutionRow {
            changeResolution()
        }
        else if indexPath.row == logoutRow {
            logout()
        }
    }

    private func changeResolution() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: SegueIdentifier.SettingsViewController.showResolutionOptions, sender: nil)
        }
    }

    private func logout() {
        Task {
            let opResponse = await logoutOperation.get(request: LogoutRequest())
            if let error = opResponse.error {
                self.logger.error("Error logging out \(error)")
            }
            self.appWiper.clean()
            AppDelegate.instance.topNavigationController?.clearAndGoToLoginView()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if segue.identifier == "ShowResolutionOptions" {
            let picker = segue.destination as! PickerViewController
            picker.delegate = self
            picker.label = "Change Default Video Quality"
            picker.options = DeliveryKeyQualityLevel.vodCases
            let selectedSetting = AppSettings.instance.qualitySettings
            if let selectedIndex = DeliveryKeyQualityLevel.vodCases.firstIndex(of: selectedSetting) {
                picker.selectedIndex = selectedIndex
            }
        }
    }
}

extension SettingsViewController: PickerDelegate {
    func picker(didSelect row: Int) {
        AppSettings.instance.qualitySettings = DeliveryKeyQualityLevel.vodCases[row]
    }
}
