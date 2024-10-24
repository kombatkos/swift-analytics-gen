//
//  SpreadsheetEventsParser.swift
//  
//
//  Created by Alexander Filimonov on 01/03/2020.
//

final class SpreadsheetEventsParser {

    // MARK: - Private Properties

    private let spreadsheet: Spreadsheet

    // MARK: - Initialization

    init(spreadsheet: Spreadsheet) {
        self.spreadsheet = spreadsheet
    }

    // MARK: - Public Methods

    public func parse() -> [EventCategory] {
        var categories: [EventCategory] = []

        var category: EventCategory?
        var event: Event?
        var parameter: Parameter?

        for row in spreadsheet.values {
            let currentCategoryName = row[safe: 0]?.nilIfEmpty()
            let currentCategoryDescription = row[safe: 1]?.nilIfEmpty()
            let currentEventName = row[safe: 2]?.nilIfEmpty()
            let currentEventDescription = row[safe: 3]?.nilIfEmpty()
            let currentParameterName = row[safe: 4]?.nilIfEmpty()
            let currentParameterType = row[safe: 5]?.nilIfEmpty()
            let currentParameterDescription = row[safe: 6]?.nilIfEmpty()

            if let currentCategoryNameUnwrapped = currentCategoryName {
                if let parameterUnwrapped = parameter, let eventUnwrapped = event {
                    event = .init(name: eventUnwrapped.name,
                                  description: eventUnwrapped.description,
                                  parameters: eventUnwrapped.parameters + [parameterUnwrapped])
                    parameter = nil
                }
                if let eventUnwrapped = event, let categoryUnwrapped = category {
                    category = .init(name: categoryUnwrapped.name,
                                     description: categoryUnwrapped.description,
                                     events: categoryUnwrapped.events + [eventUnwrapped])
                    event = nil
                }
                if let categoryUnwrapped = category {
                    categories.append(categoryUnwrapped)
                    category = nil
                }
                category = .init(name: currentCategoryNameUnwrapped,
                                 description: currentCategoryDescription,
                                 events: [])
            }

            if let currentEventNameUnwrapped = currentEventName {
                if let parameterUnwrapped = parameter, let eventUnwrapped = event {
                    event = .init(name: eventUnwrapped.name,
                                  description: eventUnwrapped.description,
                                  parameters: eventUnwrapped.parameters + [parameterUnwrapped])
                    parameter = nil
                }
                if let eventUnwrapped = event, let categoryUnwrapped = category {
                    category = .init(name: categoryUnwrapped.name,
                                     description: categoryUnwrapped.description,
                                     events: categoryUnwrapped.events + [eventUnwrapped])
                    event = nil
                }
                event = .init(name: currentEventNameUnwrapped,
                              description: currentEventDescription,
                              parameters: [])
            }

            if
                let currentParameterNameUnwrapped = currentParameterName,
                let currentParameterTypeUnwrapped = currentParameterType
            {
                if let parameterUnwrapped = parameter, let eventUnwrapped = event {
                    event = .init(name: eventUnwrapped.name,
                                  description: eventUnwrapped.description,
                                  parameters: eventUnwrapped.parameters + [parameterUnwrapped])
                    parameter = nil
                }
                parameter = .init(name: currentParameterNameUnwrapped,
                                  description: currentParameterDescription,
                                  type: .init(raw: currentParameterTypeUnwrapped))
            }

        }

        if let parameterUnwrapped = parameter, let eventUnwrapped = event {
            event = .init(name: eventUnwrapped.name,
                          description: eventUnwrapped.description,
                          parameters: eventUnwrapped.parameters + [parameterUnwrapped])
            parameter = nil
        }
        if let eventUnwrapped = event, let categoryUnwrapped = category {
            category = .init(name: categoryUnwrapped.name,
                             description: categoryUnwrapped.description,
                             events: categoryUnwrapped.events + [eventUnwrapped])
            event = nil
        }
        if let categoryUnwrapped = category {
            categories.append(categoryUnwrapped)
            category = nil
        }

        return categories
    }

}
