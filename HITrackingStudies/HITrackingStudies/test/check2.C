void dump(TObject *obj, int depth) {
  TString pad(' ', depth*2);
  if (obj->InheritsFrom("TDirectory")) {
    TDirectory *d = (TDirectory*)obj;
    printf("%s[DIR] %s/\n", pad.Data(), d->GetName());
    TIter next(d->GetListOfKeys());
    TKey *k;
    while ((k = (TKey*)next())) {
      TObject *o = k->ReadObj();
      if (o->InheritsFrom("TDirectory")) dump(o, depth+1);
      else if (o->InheritsFrom("TH1"))
        printf("%s  %-20s %-10s entries=%g\n", pad.Data(),
               k->GetName(), o->ClassName(), ((TH1*)o)->GetEntries());
      else
        printf("%s  %-20s %-10s (non-TH1)\n", pad.Data(),
               k->GetName(), o->ClassName());
    }
  }
}
void check2() {
  TFile *f = TFile::Open("OO_trkEff_pixcut.root");
  if (!f || f->IsZombie()) { printf("FILE DID NOT OPEN\n"); return; }
  dump(f, 0);
}
