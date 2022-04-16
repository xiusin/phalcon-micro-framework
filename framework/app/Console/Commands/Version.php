<?php

namespace App\Console\Commands;

use Conso\Command;
use Conso\Contracts\CommandInterface;
use Conso\Contracts\InputInterface;
use Conso\Contracts\OutputInterface;

class Version extends Command implements CommandInterface
{
    /**
     * 命令描述
     *
     * @var string
     */
    protected $description = '获取框架版本.';

    public function execute(InputInterface $input, OutputInterface $output): void
    {
        $output->success("version v0.0.1-dev");
    }
}
