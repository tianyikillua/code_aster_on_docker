def configure(self):
    self.env.append_value('LIB_METIS', ('parmetis'))
    self.env.append_value('LIB_SCOTCH', ('ptscotch', 'ptscotcherr', 'ptscotcherrexit'))
