Гатовы патч беларускай лакалізацыі для **Hermes One Desktop 0.7.9**.

## Як паставіць

1. Усталюйце Hermes One Desktop 0.7.9.
2. Спампуйце ў адну папку файлы `app.asar` і `install-be.ps1`.
3. Запусціце PowerShell:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\install-be.ps1
   ```

4. Адкрыйце Hermes One → **Налады → Мова → Беларуская**.

> Калі Windows пазначыў спампаваны скрыпт як заблакаваны, спачатку
> выканайце `Unblock-File .\install-be.ps1`.

## Праверка цэласнасці

```
SHA256(app.asar) = b9084b4362feaced9df41c9bcb414d8c76087796734a4de39688d816f44d8371
```

Параўнаць можна так:

```powershell
Get-FileHash .\app.asar -Algorithm SHA256
```

## Адкат

Скрыпт захоўвае арыгінал як `app.asar.backup` у
`%LOCALAPPDATA%\Programs\hermes-desktop\resources\`. Каб вярнуць англійскую
мову (пры закрытай праграме):

```powershell
Copy-Item "$env:LOCALAPPDATA\Programs\hermes-desktop\resources\app.asar.backup" "$env:LOCALAPPDATA\Programs\hermes-desktop\resources\app.asar" -Force
```

## Заўвагі

- Патч толькі для версіі **0.7.9**.
- Гэта неафіцыйная лакалізацыя; арыгінальная праграма — MIT.
- Поўнае апісанне і зборка з зыходнікаў — у [README](https://github.com/yurashet/hermes-belarusian#readme).
