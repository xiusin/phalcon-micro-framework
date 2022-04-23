<?php

namespace App\Console\Commands;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class Version extends Command
{
    /**
     * 命令描述
     *
     * @var string
     */
    protected static $defaultName = 'app:version';

    public function execute(InputInterface $input, OutputInterface $output): int
    {
        $output->success("version v0.0.1-dev");
    }
}
