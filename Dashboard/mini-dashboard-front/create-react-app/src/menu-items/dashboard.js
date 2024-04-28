// assets
import { IconDashboard, IconServer } from '@tabler/icons-react';

// constant
const icons = { IconDashboard, IconServer };

// ==============================|| DASHBOARD MENU ITEMS ||============================== //

const dashboard = {
  id: 'dashboard',
  title: 'Dashboard',
  type: 'group',
  children: [
    {
      id: 'default',
      title: '전체 서버 요약',
      type: 'item',
      url: '/dashboard/default',
      icon: icons.IconDashboard,
      breadcrumbs: false
    },

    {
      id: 'server',
      title: '서버별 진단 결과',
      type: 'collapse',
      icon: icons.IconServer,
      children: [ // 하위 메뉴 항목 추가
        {
          id: 'server-summary',
          title: '서버 정보 및 점검 요약',
          type: 'item',
          url: '/server/server-summary',
          breadcrumbs: false
        },
        {
          id: 'server-detail',
          title: '상세 진단 결과',
          type: 'item',
          url: '/server/server-detail',
          breadcrumbs: false
        },
        {
          id: 'server-interview',
          title: '인터뷰 필요 항목',
          type: 'item',
          url: '/server/server-interview',
          breadcrumbs: false
        },
        {
          id: 'server-vuln',
          title: '주요 취약 항목',
          type: 'item',
          url: '/server/server-vuln',
          breadcrumbs: false
        }
      ]
    }
    
  ]
};

export default dashboard;
