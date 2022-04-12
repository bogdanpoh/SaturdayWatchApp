//
//  ApplicationsController.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 11.04.2022.
//

import WatchKit

class ApplicationsController: WKInterfaceController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var applicationsTable: WKInterfaceTable!
    
    // MARK: - Lifecycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        setTitle("Applications")
    }
    
    override func willActivate() {
        super.willActivate()
        
        NetworkManager.shared.getApplications() { [weak self] result in
            switch result {
            case .failure(let error):
                print("[dev] application error \(error)")
                
            case .success(let response):
                self?.applicationsResponse = response
                self?.setupTable(applicationsResponse: response)
            }
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    // MARK: - Private
    
    private var applicationsResponse: ApplicationsResponse?
    
}

// MARK: - Setup

private extension ApplicationsController {
    
    func setupTable(applicationsResponse: ApplicationsResponse) {
        applicationsTable.setNumberOfRows(applicationsResponse.count, withRowType: "ApplicationRow")
        
        for (index, applicationName) in applicationsResponse.applications.enumerated() {
            if let controller = applicationsTable.rowController(at: index) as? ApplicationRow {
                controller.set(title: applicationName)
            }
        }
    }
    
}

// MARK: - User interactions

extension ApplicationsController {
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        super.table(table, didSelectRowAt: rowIndex)
        guard let applicationsResponse = applicationsResponse else { return }
        let application = applicationsResponse.applications[rowIndex]
        
        let deleteAction = WKAlertAction(title: "Close", style: .destructive) {
            NetworkManager.shared.postApplication(application) { [weak self] (response, error) in
                guard error == nil else {
                    print("[dev] \(error!)")
                    return
                }
                
                guard let response = response else { return }
                self?.applicationsTable.removeRows(at: .init(integer: rowIndex))
                print("[dev] message: \(response.message)")
            }
        }
        
        let cancelAction = WKAlertAction(title: "Cancel", style: .cancel) {}
        
        presentAlert(withTitle: "Close application?", message: application, preferredStyle: .actionSheet, actions: [deleteAction, cancelAction])
    }
    
}
