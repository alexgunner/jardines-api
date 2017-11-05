room = Booking::Room.create!(name: "Jaguar", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id egestas quam. Maecenas gravida metus a fermentum pellentesque. Pellentesque ultrices eu ex ut eleifend. Aenean vehicula dignissim purus, vitae cursus.", capacity: 2)
price = Booking::Price.create!(room: room, one_guest: 321, two_guests: 435 , status: Booking::Price::CURRENT)

room = Booking::Room.create!(name: "Jucumari", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id egestas quam. Maecenas gravida metus a fermentum pellentesque. Pellentesque ultrices eu ex ut eleifend. Aenean vehicula dignissim purus, vitae cursus.", capacity: 2)
price = Booking::Price.create!(room: room, one_guest: 135, two_guests: 433, status: Booking::Price::CURRENT)

room = Booking::Room.create!(name: "Panda", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id egestas quam. Maecenas gravida metus a fermentum pellentesque. Pellentesque ultrices eu ex ut eleifend. Aenean vehicula dignissim purus, vitae cursus.", capacity: 2)
price = Booking::Price.create!(room: room, one_guest: 65, two_guests: 125, status: Booking::Price::CURRENT)

room = Booking::Room.create!(name: "Dolphin", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id egestas quam. Maecenas gravida metus a fermentum pellentesque. Pellentesque ultrices eu ex ut eleifend. Aenean vehicula dignissim purus, vitae cursus.", capacity: 2)
price = Booking::Price.create!(room: room, one_guest: 125, two_guests: 435, status: Booking::Price::CURRENT)

room = Booking::Room.create!(name: "Lion", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id egestas quam. Maecenas gravida metus a fermentum pellentesque. Pellentesque ultrices eu ex ut eleifend. Aenean vehicula dignissim purus, vitae cursus.", capacity: 2)
price = Booking::Price.create!(room: room, one_guest: 80, two_guests: 125, status: Booking::Price::CURRENT)

room = Booking::Room.create!(name: "Tortoise", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id egestas quam. Maecenas gravida metus a fermentum pellentesque. Pellentesque ultrices eu ex ut eleifend. Aenean vehicula dignissim purus, vitae cursus.", capacity: 2)
price = Booking::Price.create!(room: room, one_guest: 458, two_guests: 865, status: Booking::Price::CURRENT)

room = Booking::Room.create!(name: "Pantera", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id egestas quam. Maecenas gravida metus a fermentum pellentesque. Pellentesque ultrices eu ex ut eleifend. Aenean vehicula dignissim purus, vitae cursus.", capacity: 2)
price = Booking::Price.create!(room: room, one_guest: 325, two_guests: 465, status: Booking::Price::CURRENT)

room = Booking::Room.create!(name: "Timon y Pumba", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer id egestas quam. Maecenas gravida metus a fermentum pellentesque. Pellentesque ultrices eu ex ut eleifend. Aenean vehicula dignissim purus, vitae cursus.", capacity: 4)
price = Booking::Price.create!(room: room, one_guest: 987, two_guests: 987, status: Booking::Price::CURRENT)

