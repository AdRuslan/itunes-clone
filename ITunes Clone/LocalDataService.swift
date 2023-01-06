//
//  LocalDataService.swift
//  ITunes Clone
//
//  Created by Руслан Адигамов on 05.01.2023.
//

import Foundation
import CoreData

final class LocalDataService {

    private lazy var container: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "ITunes_Clone")
        persistentContainer.loadPersistentStores { _, _ in }
        return persistentContainer
    }()

    func getImage(by url: String) -> Data? {
        let fetchRequest = Entity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url = %@", url)
        do {
            let entities = try container.viewContext.fetch(fetchRequest)

            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            
            guard let ent = entities.first else {return nil}
                guard let uuid = ent.image else {
                    return nil
                }
                let imagePath = documentsDirectory.appending(path: uuid.uuidString)

                return try? Data(contentsOf: imagePath)
                
            } catch {
            print(error)
            return nil
        }
    }

    func saveImage(data: Data, from url: String) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var documentsDirectory = paths[0]
        let uuid = UUID()
        documentsDirectory.append(path: uuid.uuidString)

        try? data.write(to: documentsDirectory)

        let context = container.newBackgroundContext()

        context.perform {
            print("Is main thread", Thread.isMainThread)
            let entity = Entity(context: context)
            entity.image = uuid
            entity.url = url
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print(error)
                }
            }
        }
    }
}
