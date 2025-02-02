/*
 * Copyright 2019-2022 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.vividus.selenium.mobileapp.screenshot;

import static pazone.ashot.ShootingStrategies.scaling;

import java.util.Optional;

import org.vividus.selenium.mobileapp.MobileAppWebDriverManager;
import org.vividus.selenium.mobileapp.screenshot.strategies.MobileViewportShootingStrategy;
import org.vividus.selenium.screenshot.AbstractAshotFactory;
import org.vividus.selenium.screenshot.ScreenshotCropper;
import org.vividus.ui.screenshot.ScreenshotParameters;

import pazone.ashot.AShot;
import pazone.ashot.ShootingStrategies;
import pazone.ashot.ShootingStrategy;
import pazone.ashot.coordinates.CoordsProvider;

public class MobileAppAshotFactory extends AbstractAshotFactory<ScreenshotParameters>
{
    private final MobileAppWebDriverManager mobileAppWebDriverManager;
    private final CoordsProvider coordsProvider;
    private boolean downscale;
    private boolean appendBottomNavigationBarOnAndroid;

    public MobileAppAshotFactory(ScreenshotCropper screenshotCropper, MobileAppWebDriverManager genericWebDriverManager,
            CoordsProvider coordsProvider)
    {
        super(screenshotCropper);
        this.mobileAppWebDriverManager = genericWebDriverManager;
        this.coordsProvider = coordsProvider;
    }

    @Override
    public AShot create(Optional<ScreenshotParameters> screenshotParameters)
    {
        String strategyName = screenshotParameters.flatMap(ScreenshotParameters::getShootingStrategy)
                .orElseGet(this::getScreenshotShootingStrategy);

        ShootingStrategy strategy;
        if (appendBottomNavigationBarOnAndroid && mobileAppWebDriverManager.isAndroid())
        {
            strategy = getStrategyBy(strategyName).getDecoratedShootingStrategy(ShootingStrategies.simple());
            int statusBarSize = mobileAppWebDriverManager.getStatusBarSize();
            strategy = decorateWithFixedCutStrategy(strategy, statusBarSize, 0);
        }
        else
        {
            strategy = getStrategyBy(strategyName).getDecoratedShootingStrategy(new MobileViewportShootingStrategy());
            strategy = downscale ? scaling(strategy, (float) this.getDpr()) : strategy;
        }

        if (screenshotParameters.isPresent())
        {
            strategy = decorateWithCropping(strategy, screenshotParameters.get());
        }

        return new AShot().shootingStrategy(strategy).coordsProvider(coordsProvider);
    }

    @Override
    protected double getDpr()
    {
        return mobileAppWebDriverManager.getDpr();
    }

    public void setDownscale(boolean downscale)
    {
        this.downscale = downscale;
    }

    public void setAppendBottomNavigationBarOnAndroid(boolean appendBottomNavigationBarOnAndroid)
    {
        this.appendBottomNavigationBarOnAndroid = appendBottomNavigationBarOnAndroid;
    }
}
