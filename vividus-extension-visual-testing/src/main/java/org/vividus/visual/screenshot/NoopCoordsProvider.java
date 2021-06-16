package org.vividus.visual.screenshot;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

import ru.yandex.qatools.ashot.coordinates.Coords;
import ru.yandex.qatools.ashot.coordinates.CoordsProvider;

public class NoopCoordsProvider extends CoordsProvider
{
    @Override
    public Coords ofElement(WebDriver arg0, WebElement arg1)
    {
        throw new UnsupportedOperationException();
    }
}
