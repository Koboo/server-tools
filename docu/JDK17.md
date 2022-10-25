# Dirty workaround to modify `private final` Fields in JDK17

This utility class will only work with the following start arguments:

```java --add-opens java.base/java.lang=ALL-UNNAMED --add-opens java.base/java.lang.reflect=ALL-UNNAMED -jar {jar-name}.jar```

*Source-Code:*
```java
import java.lang.invoke.MethodHandles;
import java.lang.invoke.VarHandle;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;

public final class FieldHelper {

    private static final VarHandle MODIFIERS;

    static {
        try {
            var lookup = MethodHandles.privateLookupIn(Field.class, MethodHandles.lookup());
            MODIFIERS = lookup.findVarHandle(Field.class, "modifiers", int.class);
        } catch (IllegalAccessException | NoSuchFieldException ex) {
            throw new RuntimeException(ex);
        }
    }

    public static void makeNonFinal(Field field) {
        int mods = field.getModifiers();
        if (Modifier.isFinal(mods)) {
            MODIFIERS.set(field, mods & ~Modifier.FINAL);
        }
    }

}
```
