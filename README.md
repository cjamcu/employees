# Employees App 📱

## 📝 Resumen del Proyecto

Employees App es una aplicación Flutter diseñada para gestionar información de empleados de manera eficiente. Ofrece las siguientes funcionalidades:

- 📋 Visualizar una lista de empleados con paginación infinita (10 elementos por página)
- ➕ Agregar nuevos empleados con validación de datos
- ✏️ Editar información de empleados existentes
- 🔍 Filtrar y buscar empleados
- 🗑️ Eliminar registros de empleados

La aplicación utiliza Firebase como backend para el almacenamiento y recuperación de datos en tiempo real.

## 🏗️ Arquitectura

El proyecto implementa Clean Architecture con el patrón BLoC (Business Logic Component), siguiendo los principios SOLID. La estructura está organizada por features y capas:

```
lib/
├── app/
│   ├── app.dart
│   └── colors.dart
├── core/
│   └── di.dart
└── features/
    └── employees/
        ├── data/
        │   ├── datasources/
        │   ├── models/
        │   └── repositories/
        ├── domain/
        │   ├── entities/
        │   ├── repositories/
        │   ├── usecases/
        │   └── validators/
        └── presentation/
            ├── bloc/
            ├── screens/
            └── widgets/
```

### Capas de la Arquitectura:

- **Presentación**: Contiene las pantallas, widgets y BLoCs.
- **Dominio**: Define entidades, casos de uso y contratos de repositorios.
- **Datos**: Implementa repositorios y maneja fuentes de datos.

## 🛠️  Dependencias Principales

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  get_it: ^7.6.0
  cloud_firestore: ^4.8.0
  firebase_storage: ^11.2.2
  image_picker: ^0.8.7
  equatable: ^2.0.5
  intl: ^0.18.0
```

## 🚀 Configuración y Ejecución

1. **Clonar el Repositorio**
   ```bash
   git clone https://github.com/cjamcu/employees.git
   cd employees
   ```

2. **Instalar Dependencias**
   ```bash
   flutter pub get
   ```

3. **Generar Archivos de Localización**
   ```bash
   flutter gen-l10n
   ```
   
4. **Ejecutar la Aplicación**
   ```bash
   flutter run
   ```

## 🧪 Testing

La estrategia de testing cubre diferentes componentes de la aplicación:

```
test/
└── features/
    └── employees/
        ├── data/
        │   ├── datasources/
        │   └── repositories/
        ├── domain/
        │   ├── usecases/
        │   └── validators/
        └── presentation/
            └── bloc/
```

### Componentes Probados

- **Validators**: Pruebas para las funciones de validación de datos de empleados.
- **Usecases**: Verificación de la lógica de negocio, como la generación de correos electrónicos de empleados.
- **BLoCs**: Pruebas para la lógica de estado en los BLoCs, tanto para el formulario como para la lista de empleados.
- **Datasources**: Validación de la interacción con las fuentes de datos de Firebase.
- **Repositories**: Aseguran el correcto funcionamiento de los repositorios de empleados y archivos.

### Ejecutar Tests

```bash
flutter test
```

Para ver un informe detallado de la cobertura de pruebas, puedes ejecutar:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

Esto generará un informe HTML que puedes ver en tu navegador abriendo el archivo `coverage/html/index.html`.

## 🌐 Internacionalización

La aplicación soporta múltiples idiomas:

- 🇪🇸 Español
- 🇺🇸 Inglés

Los archivos de traducción se encuentran en `lib/l10n/`. Para agregar o modificar traducciones, edita los archivos ARB correspondientes y ejecuta `flutter gen-l10n`.

