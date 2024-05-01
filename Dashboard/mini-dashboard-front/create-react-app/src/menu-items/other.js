// assets
import { IconBrandGithub, IconHelp } from '@tabler/icons-react';

// constant
const icons = { IconBrandGithub, IconHelp };

// ==============================|| SAMPLE PAGE & DOCUMENTATION MENU ITEMS ||============================== //

const other = {
  id: 'github-docs-roadmap',
  type: 'group',
  children: [
    {
      id: 'github-page',
      title: 'Github Page',
      type: 'item',
      url: 'https://github.com/ehfhfhd/Sonicboom.git',
      icon: icons.IconBrandGithub,
      breadcrumbs: false,
      target: '_blank'
    },
    {
      id: 'documentation',
      title: 'Documentation',
      type: 'item',
      url: 'https://codedthemes.gitbook.io/berry/',
      icon: icons.IconHelp,
      external: true,
      target: true
    }
  ]
};

export default other;
