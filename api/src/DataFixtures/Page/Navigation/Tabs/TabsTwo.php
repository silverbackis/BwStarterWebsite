<?php

namespace App\DataFixtures\Page\Navigation\Tabs;

use Doctrine\Common\DataFixtures\DependentFixtureInterface;
use Doctrine\Common\Persistence\ObjectManager;
use Silverback\ApiComponentBundle\DataFixtures\Page\AbstractPage;
use Silverback\ApiComponentBundle\Factory\Component\ContentFactory;

class TabsTwo extends AbstractPage implements DependentFixtureInterface
{
    /**
     * @param ObjectManager $manager
     * @throws \BadMethodCallException
     * @throws \Psr\Container\ContainerExceptionInterface
     */
    public function load(ObjectManager $manager)
    {
        parent::load($manager);

        $this->entity->setTitle('Tabs Two');
        $this->entity->setMetaDescription('Tabs Link Two');
        $this->entity->setParent($this->getReference('page.navigation.tabs'));
        $this->createComponent(ContentFactory::class);
        $this->flush();
        $this->addReference('page.navigation.tabs.tab2', $this->entity);
    }

    public function getDependencies()
    {
        return [
            TabsNavbarPage::class
        ];
    }
}
