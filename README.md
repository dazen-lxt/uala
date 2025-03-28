# 🌍 City Explorer App

Una aplicación moderna desarrollada en SwiftUI para explorar y gestionar una lista de ciudades. Incluye búsqueda inteligente, favoritos persistentes, vistas adaptativas y un enfoque arquitectónico modular que promueve mantenibilidad, testabilidad y escalabilidad.

---

## 🎯 Objetivo

Proveer una solución mobile intuitiva y eficiente para explorar ciudades del mundo. La app permite buscar ciudades con `debounce`, verlas en mapa, marcarlas como favoritas y mantener esos datos sincronizados gracias a CoreData. Todo en una arquitectura pensada para escalar.

---

## 💡 Principales Funciones

| Funcionalidad      | Descripción |
|--------------------|-------------|
| 🔍 Búsqueda         | Reactiva con `debounce` de 0.8s |
| ⭐ Favoritos        | Persistencia local con CoreData |
| 🌐 Carga Remota     | Inicial con JSON desde endpoint remoto |
| 💾 Cache Local      | CoreData como única fuente de verdad |
| 🧭 Vista Mapa       | Mapa centrado en coordenadas de ciudad |
| 🧩 UI Adaptativa    | Compatible con orientación y tamaño de dispositivo |
| 🧪 UI Testing Ready | Listo para pruebas automatizadas con mocks |

---

## 🧪 Identificadores para UI Tests

| Identificador        | Elemento                           |
|----------------------|------------------------------------|
| `"cityList"`         | Lista principal de ciudades        |
| `"cityCell_\(id)"`   | Cada celda de ciudad               |
| `"emptyMessage"`     | Texto mostrado sin resultados      |

---

## 💽 CoreData: Almacenamiento Local

La app usa **CoreData como única fuente de verdad** una vez se ha cargado la data inicial del servidor.

### Persistencia de Ciudades

Se almacenan todas las ciudades localmente al iniciar.

Se usa `searchKey` como índice compuesto (`name + country`) para búsqueda y orden:

```swift
entity.searchKey = city.name + ", " + city.country
Esto permite que el filtro y el ordenamiento se realicen directamente en el query de CoreData.
```

## ⭐ Favoritos

Los favoritos se almacenan en una entidad separada llamada `FavoriteEntity`, que guarda los **IDs de las ciudades marcadas**.

### Se puede:

- ✅ Agregar un favorito
- ❌ Eliminar un favorito
- 📋 Consultar todos los favoritos actuales

Todo esto se realiza de forma **asíncrona y segura** con `context.perform`.

---

## 🧰 CityStorage

Clase responsable de abstraer y encapsular todas las operaciones con CoreData.

```swift
final class CityStorage: CityStorageProtocol {
    private let context: NSManagedObjectContext

    func fetchPagedCitiesFromCoreData(...) -> [City] { ... }
    func saveCities(...) async { ... }
    func hasStoredCities() -> Bool { ... }

    func fetchFavorites() async throws -> [Int] { ... }
    func addFavorite(_ cityId: Int) async throws { ... }
    func removeFavorite(_ cityId: Int) async throws { ... }
}
```

## 🌐 CityService

Clase encargada de obtener los datos remotos desde un archivo JSON disponible públicamente.

```swift
final class CityService: CityServiceProtocol {
    func fetchCities() async throws -> [City] {
        // Fetch desde Gist de GitHub
    }
}
```

## 📁 Estructura del Proyecto
```bash
CityExplorer/
├── AppContainer/              # Inyección de dependencias
│   └── AppContainer.swift
├── Models/                    # Modelos de datos: City, Coordinate
│   ├── City.swift
│   └── Coordinate.swift
├── Views/                     # Vistas SwiftUI
│   ├── CityListView.swift
│   ├── CityCellView.swift
│   └── CityMapView.swift
├── ViewModels/                # Lógica de presentación (MVVM)
│   └── CityListViewModel.swift
├── Services/                  # Acceso remoto de datos (JSON remoto)
│   └── CityService.swift
├── Storage/                   # Persistencia local CoreData
│   └── CityStorage.swift
├── Repository/                # Repositorio intermedio entre VM y Data
│   └── CityRepository.swift
├── CoreData/                  # Stack e Interfaces
│   ├── CoreDataStack.swift
│   └── .xcdatamodeld
├── Previews/                  # MockData para SwiftUI Preview
├── UalaTests/                 # Testing con mocks
├── UalaUITests/               # UI Testing con mocks
├── Resources/
│   └── Assets.xcassets
└── README.md                  # 📄 Este archivo
```


## 🚀 Cómo Ejecutar

1. Clona el repositorio.
2. Abre el proyecto en Xcode.
3. Selecciona el esquema `CityExplorer` y corre en un simulador.

### Para correr los UI Tests:

```bash
xcodebuild test \
  -scheme CityExplorer \
  -destination 'platform=iOS Simulator,name=iPhone 14' \
  -enableCodeCoverage YES \
  -testPlan CityExplorerUITests \
  -arguments 'UI-TESTING' \
  -environment 'MOCK_CITY_COUNT=100'
```

## 📌 Requisitos

- Xcode 15+
- iOS 17+
- Conexión a internet para la carga inicial de datos

---

## 📬 Autor

Desarrollado por Carlos Muñoz para Ualá, siguiendo las mejores prácticas de desarrollo en SwiftUI y arquitectura limpia. ✨
