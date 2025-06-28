//
//  DbController.swift
//  SampleInterviewSwiftUI
//
//  Created by giora krasilshchik on 28/06/2025.
//

import CoreData

protocol DbActions {
    func fetchMovies() -> [Movie]
    func addMovie(title: String, year: String)
}

class PersistenceController: DbActions {
    
    var context: NSManagedObjectContext {
           container.viewContext
       }
    
    func addMovie(title: String, year: String) {
        let newMovie = Movie(context: context)
        newMovie.title = title
        newMovie.year = year
        newMovie.movieId = UUID()
        try? context.save()
    }
    
    func fetchMovies() -> [Movie] {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model") // <- name of .xcdatamodeld
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
    }
}
